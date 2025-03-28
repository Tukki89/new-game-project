extends Area2D

var player: Node2D = null
var player_in_chat_zone = false
var is_chatting = false
var dialogue_played = false

@export var swan_princess_scene: PackedScene  # Swan Princess scene
@export var rothbart_scene: PackedScene  # Rothbart scene
@export var spawn: NodePath  # Marker2D for Swan Princess (renamed)
@export var rspawn: NodePath  # Marker2D for Rothbart
@export var dialog_id: String = "Confrontation"  # Dialogic event ID

var swan_princess: Node2D = null
var rothbart: Node2D = null

func _ready():
	print("DEBUG: Cinematic script initialized.")
	
	rothbart_scene = load("res://dialogicchar/rothbart.tscn")  # Load Rothbart
	swan_princess_scene = load("res://dialogicchar/swanprincess.tscn")  # Load Swan Princess
	
	Dialogic.signal_event.connect(_on_dialogic_event)  # Listen for `[end_timeline]`

	

func _process(delta: float) -> void:
	if player_in_chat_zone and not is_chatting and not dialogue_played:
		run_dialogue(dialog_id)

func run_dialogue(dialogue_string):
	is_chatting = true
	dialogue_played = true
	spawn_characters()  
	Dialogic.start(dialogue_string)
	print("DEBUG: Started dialogue and spawned characters.")

func spawn_characters():
	var swan_point = get_node_or_null("spawn")
	var roth_point = get_node_or_null("rspawn")

	if swan_point:
		swan_princess = swan_princess_scene.instantiate()
		swan_princess.position = swan_point.global_position
		get_parent().add_child(swan_princess)
		print("DEBUG: Spawned Swan Princess at", swan_point.global_position)

	if roth_point:
		rothbart = rothbart_scene.instantiate()
		rothbart.position = roth_point.global_position
		get_parent().add_child(rothbart)
		print("DEBUG: Spawned Rothbart at", roth_point.global_position)

func _on_dialogic_event(event_name: String, _args):
	print("DEBUG: Dialogic Event ->", event_name)  # Debug event trigger

	if event_name == "end_timeline":
		print("DEBUG: Dialogue ended, scheduling removal of characters.")
		await get_tree().create_timer(0.2).timeout  # Small delay to ensure proper removal

		if swan_princess:
			print("DEBUG: Removing Swan Princess ->", swan_princess.name)
			swan_princess.queue_free()
			swan_princess = null
		else:
			print("WARNING: Swan Princess was already removed or null.")

		if rothbart:
			print("DEBUG: Removing Rothbart ->", rothbart.name)
			swan_princess.get_parent().remove_child(swan_princess)  # Forceful removal
			rothbart.queue_free()
			rothbart = null
		else:
			print("WARNING: Rothbart was already removed or null.")

		is_chatting = false

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
