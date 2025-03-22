extends CharacterBody2D

@export var speed: float = 50.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var idle_animations = ["idle_1", "idle_2", "idle_3", "idle_4"]
var walk_animations = ["walk_1", "walk_2"]
var rng = RandomNumberGenerator.new()

var move_timer: float = 0.0
var move_direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.ZERO
var last_animation: String = ""

func _ready():
	randomize()
	_choose_new_direction()

func _process(delta):
	move_timer -= delta
	if move_timer <= 0:
		_choose_new_direction()
	
	if move_direction != Vector2.ZERO:
		velocity = move_direction * speed
		if move_direction != last_direction:
			_play_walk_animation()
	else:
		velocity = Vector2.ZERO
		if last_animation not in idle_animations:
			_play_random_idle()
	
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
	
	last_direction = move_direction
	move_and_slide()

func _choose_new_direction():
	move_timer = rng.randf_range(1.5, 3.0)  # Change direction every 1.5 to 3 seconds
	var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN, Vector2.ZERO]  # Zero means idle
	move_direction = directions[rng.randi_range(0, directions.size() - 1)]

func _play_walk_animation():
	last_animation = walk_animations[rng.randi_range(0, walk_animations.size() - 1)]
	sprite.play(last_animation)

func _play_random_idle():
	last_animation = idle_animations[rng.randi_range(0, idle_animations.size() - 1)]
	sprite.play(last_animation)
