extends Area2D

var player: Node2D = null
var player_in_chat_zone = false
var is_chatting = false
var dialogue_played = false

@export var swan_princess_scene: PackedScene  # Swan Princess scene
@export var rothbart_scene: PackedScene  # Rothbart scene
@export var spawn: NodePath  # Marker2D for Swan Princess (renamed)
@export var rspawn: NodePath  # Marker2D for Rothbart
@export var dialog_id: String = "OutsideCastle"  # Dialogic event ID

func _ready():
	print("DEBUG: Cinematic script initialized.")
	
	rothbart_scene = load("res://dialogicchar/rothbart.tscn")  # Load Rothbart
	print("DEBUG: Rothbart scene loaded manually.")
	
	swan_princess_scene = load("res://dialogicchar/swanprincess.tscn")  # Load Swan Princess
	print("DEBUG: Swan Princess scene loaded manually.")
	
	print("DEBUG: rothbart_scene is", rothbart_scene)
	print("DEBUG: swan_princess_scene is", swan_princess_scene)

	var roth_point = get_node_or_null("rspawn")
	if roth_point:
		print("DEBUG: Rothbart spawn marker found:", roth_point)
	else:
		print("ERROR: Rothbart spawn marker not found! Check the scene hierarchy.")

	var swan_point = get_node_or_null("spawn")  # Corrected spawn marker name
	if swan_point:
		print("DEBUG: Swan Princess spawn marker found:", swan_point)
	else:
		print("ERROR: Swan Princess spawn marker not found! Check the scene hierarchy.")

	# Test manually spawning Rothbart
	if roth_point:
		var rothbart = rothbart_scene.instantiate()
		rothbart.position = roth_point.global_position
		get_parent().add_child(rothbart)
		print("DEBUG: Manually spawned Rothbart at", roth_point.global_position)
	else:
		print("ERROR: Failed to spawn Rothbart due to missing spawn marker")

	# Test manually spawning Swan Princess
	if swan_point:
		var swan_princess = swan_princess_scene.instantiate()
		swan_princess.position = swan_point.global_position
		get_parent().add_child(swan_princess)
		print("DEBUG: Manually spawned Swan Princess at", swan_point.global_position)
	else:
		print("ERROR: Failed to spawn Swan Princess due to missing spawn marker")

func _process(delta: float) -> void:
	if player_in_chat_zone and not is_chatting and not dialogue_played:
		run_dialogue(dialog_id)

func run_dialogue(dialogue_string):
	is_chatting = true
	dialogue_played = true
	spawn_characters()  # Spawn NPCs before starting the cutscene
	Dialogic.start(dialogue_string)
	print("DEBUG: Started dialogue and spawned characters.")

func spawn_characters():
	var swan_point = get_node_or_null("spawn")  # Corrected spawn marker name
	var roth_point = get_node_or_null("rspawn")
	print("DEBUG: Rothbart spawn marker is", roth_point)

	if swan_point:
		var swan_princess = swan_princess_scene.instantiate()
		swan_princess.position = swan_point.global_position
		get_parent().add_child(swan_princess)
		print("DEBUG: Spawned Swan Princess at", swan_point.global_position)
	else:
		print("ERROR: Swan Princess spawn marker not found!")

	if roth_point:
		var rothbart = rothbart_scene.instantiate()
		rothbart.position = roth_point.global_position
		get_parent().add_child(rothbart)
		print("DEBUG: Spawned Rothbart at", roth_point.global_position)
	else:
		print("ERROR: Rothbart spawn marker not found!")

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
