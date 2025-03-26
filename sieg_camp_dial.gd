extends Area2D

var player: Node2D = null
var player_in_chat_zone = false
var is_chatting = false
var dialogue_played = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if player_in_chat_zone and not is_chatting and not dialogue_played:
		run_dialogue("SiegCamp")

func run_dialogue(dialogue_string):
	is_chatting = true
	dialogue_played = true
	Dialogic.start(dialogue_string)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not dialogue_played:
		player = body
		player_in_chat_zone = true
		print("DEBUG: Player entered chat zone.")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_chat_zone = false
		player = null
		print("DEBUG: Player exited chat zone.")
