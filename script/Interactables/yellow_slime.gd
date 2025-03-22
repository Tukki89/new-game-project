extends CharacterBody2D

@export var speed: float = 25.0
var player: Node2D = null
var attack_triggered: bool = false  
var health: int = 10  

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  
@onready var hitbox: Area2D = $Hitbox  
@onready var detection_area: Area2D = $DetectionArea  

func _ready():
	_start_attack_timer()  

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed * (0.5 if attack_triggered else 1)  # Move slower when attacking
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	_update_animation()

func _update_animation():
	if not animated_sprite:
		return

	if attack_triggered:
		animated_sprite.play("Atk")  
		return

	if velocity.length() > 1:  
		if abs(velocity.x) > abs(velocity.y):  # Moving left/right
			animated_sprite.play("Side")
			animated_sprite.flip_h = velocity.x < 0  # Flip if moving left
		else:  # Moving up/down
			animated_sprite.play("Walk")  
	else:
		animated_sprite.play("Walk")  # Stay in Walk when idle

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "sword":  
		take_damage()

func take_damage():
	health -= 3
	if health > 0:
		animated_sprite.play("Hit")
	else:
		die()

func die():
	animated_sprite.play("Die")  
	await get_tree().create_timer(0.5).timeout  
	queue_free()  

func _start_attack_timer():
	while true:
		await get_tree().create_timer(3.0).timeout  

		if animated_sprite.sprite_frames.has_animation("Atk"):
			attack_triggered = true  
			var attack_duration = animated_sprite.sprite_frames.get_frame_count("Atk") / animated_sprite.sprite_frames.get_animation_speed("Atk")
			await get_tree().create_timer(attack_duration).timeout  

		attack_triggered = false  
