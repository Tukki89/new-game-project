extends CharacterBody2D

signal stick_collected

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var sprite = $Sprite2D  # Change to $AnimatedSprite2D if needed

enum PlayerStates { MOVE, SWORD }
var current_state = PlayerStates.MOVE
var speed = 70
var input_movement = Vector2.ZERO
var health = Player_data.player_health

func _ready():
	print(health)

func _physics_process(delta):
	match current_state:
		PlayerStates.MOVE:
			input_move()
		PlayerStates.SWORD:
			sword()

	move_and_slide()

func input_move():
	input_movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if input_movement != Vector2.ZERO:
		update_animation_blend(input_movement)
		anim_state.travel("Move")
		velocity = input_movement * speed
		flip_sprite(input_movement.x)
	else:
		anim_state.travel("Idle")    
		velocity = Vector2.ZERO

	if Input.is_action_just_pressed("ui_sword"):
		current_state = PlayerStates.SWORD

func sword():
	anim_state.travel("Sword")
	# Wait for the animation to finish before resetting state
	$AnimationTree.connect("animation_finished", Callable(self, "on_states_reset"), CONNECT_ONE_SHOT)

func on_states_reset():
	current_state = PlayerStates.MOVE

func update_animation_blend(direction: Vector2):
	anim_tree.set("parameters/Idle/blend_position", direction)
	anim_tree.set("parameters/Move/blend_position", direction)
	anim_tree.set("parameters/Sword/blend_position", direction)

func flip_sprite(direction_x: float):
	if direction_x < 0:
		sprite.flip_h = true  # Face left
	elif direction_x > 0:
		sprite.flip_h = false  # Face right


func _on_collision_shape_2d_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.


func _on_detector_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
