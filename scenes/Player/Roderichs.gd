extends CharacterBody2D

const SPEED = 30
var current_state = IDLE  

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player: Node2D = null
var player_in_chat_zone = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
	$AnimatedSprite2D.play("idle")

func _process(delta):
	if player_in_chat_zone and Input.is_action_just_pressed("chat") and not is_chatting:
		run_dialogue("RoderichSay")

	$AnimatedSprite2D.play("idle")

	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
				current_state = MOVE
			MOVE:
				move(delta)

	if Input.is_action_just_pressed("e"):
		print("DEBUG: Chatting with NPC")
		is_roaming = false
		is_chatting = true
		$AnimatedSprite2D.play("idle")

func run_dialogue(dialogue_string):
	is_chatting = true  
	is_roaming = false  
	Dialogic.start(dialogue_string)

func choose(array):
	array.shuffle()
	return array.front()

func move(_delta): 
	if not is_chatting:
		velocity = dir * SPEED
		move_and_slide()

# --- DETECTION SYSTEM --- 
func _on_chat_area_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player_in_chat_zone = true
		print("DEBUG: Player entered chat zone.")

func _on_chat_area_detection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_chat_zone = false
		player = null
		print("DEBUG: Player exited chat zone.")

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])

func _on_chat_area_detection_tree_exiting() -> void:
	player_in_chat_zone = false
	player = null
	print("DEBUG: Chat detection area reset.")

func _on_chat_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player_in_chat_zone = true
		print("DEBUG: Player detected in chat area.")

func _on_chat_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_chat_zone = false
		player = null
		print("DEBUG: Player left chat area.")
