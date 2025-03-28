extends CharacterBody2D

var player: Node2D = null
var player_in_chat_zone = false
var is_chatting = false
var dialogue_played = false

func _ready() -> void:
	if $detector is Area2D:
		if not $detector.is_connected("body_entered", Callable(self, "_on_detector_body_entered")):
			$detector.connect("body_entered", Callable(self, "_on_detector_body_entered"))
	else:
		print("ERROR: detector is missing or not an Area2D!")

func _process(delta: float) -> void:
	if player_in_chat_zone and not is_chatting and not dialogue_played:
		run_dialogue("Swanlouge")

func run_dialogue(dialogue_string):
	is_chatting = true
	dialogue_played = true
	Dialogic.start(dialogue_string)
	await get_tree().create_timer(0.1).timeout  # Ensure dialogue starts before freeing


func _on_detector_body_entered(body: CharacterBody2D) -> void:
	print("DEBUG: Something entered detector - ", body.name)
	if body.name == "Player" and not dialogue_played:
		player = body
		player_in_chat_zone = true
		print("DEBUG: Player entered chat zone.")

func _on_detector_body_exited(body: CharacterBody2D) -> void:
	print("DEBUG: Something exited detector - ", body.name)
	if body.name == "Player":
		player_in_chat_zone = false
		player = null
		print("DEBUG: Player exited chat zone.")
