extends CharacterBody2D

@export var speed: float = 25.0
var move_direction: Vector2 = Vector2.ZERO
var move_timer: float = 0.0
var rng = RandomNumberGenerator.new()

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  

func _ready():
	randomize()
	_choose_new_direction()
	_play_idle()

func _physics_process(delta):
	move_timer -= delta
	if move_timer <= 0:
		_choose_new_direction()
	
	if move_direction != Vector2.ZERO:
		velocity = move_direction * speed
		_play_run_animation()
	else:
		velocity = Vector2.ZERO
		_play_idle()
	
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true
	
	move_and_slide()

func _choose_new_direction():
	move_timer = rng.randf_range(2.0, 4.0)  # Change direction every 2-4 seconds
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN, Vector2.ZERO, Vector2.ZERO]
	move_direction = directions[rng.randi_range(0, directions.size() - 1)]

func _play_run_animation():
	animated_sprite.play("run")

func _play_idle():
	animated_sprite.play("idle_1")
