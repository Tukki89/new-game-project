extends CharacterBody2D

@export var speed: float = 25.0
var player: Node2D = null
var attack_triggered: bool = false  
var health: int = 10  # Slime has 10 slashes worth of life

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  
@onready var hitbox: Area2D = $Hitbox  # Make sure the slime has an Area2D named "Hitbox"

func _ready():
	_start_attack_timer()  
	hitbox.connect("area_entered", Callable(self, "_on_hitbox_area_entered"))

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player and not attack_triggered:
		velocity = position.direction_to(player.position) * speed

	move_and_slide()
	_update_animation()

func _update_animation():
	if not animated_sprite:
		return

	if attack_triggered:
		animated_sprite.play("Atk")  
		return

	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):  
			animated_sprite.play("Side")
			animated_sprite.flip_h = velocity.x < 0  # Flip when moving left
		else:
			animated_sprite.play("Walk")  
	else:
		animated_sprite.play("Idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null

func _on_hitbox_area_entered(area: Area2D) -> void:
	print("Hit detected from:", area.name)  

	if area.name == "sword":  
		take_damage()

func take_damage():
	var damage = calculate_damage()
	health -= damage
	print("Slime took", damage, "damage! HP left:", health)

	if health > 0:
		animated_sprite.play("Hit")
	else:
		die()

func calculate_damage() -> int:
	var rand_value = randi_range(1, 100)
	if rand_value <= 30:
		return 5
	elif rand_value <= 70:
		return 4
	elif rand_value <= 110:
		return 3
	elif rand_value <= 160:
		return 2
	else:
		return 1

func die():
	print("Slime defeated!")
	animated_sprite.play("Die")  
	await get_tree().create_timer(0.5).timeout  
	queue_free()  

func _start_attack_timer():
	while true:
		await get_tree().create_timer(3.0).timeout  

		if animated_sprite and animated_sprite.sprite_frames.has_animation("Atk"):
			attack_triggered = true  

			var frame_count = animated_sprite.sprite_frames.get_frame_count("Atk")
			var anim_speed = animated_sprite.sprite_frames.get_animation_speed("Atk")

			if anim_speed > 0:
				var attack_duration = frame_count / anim_speed
				await get_tree().create_timer(attack_duration).timeout  

		attack_triggered = false  
