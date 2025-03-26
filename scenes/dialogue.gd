extends Control

signal dialogue_finished 

@export_file("*.json") var d_file

var dialogue = []
var current_dialogue_id = 0
var d_active = false 

func _ready():
	$NinePatchRect.visible = false 

func start(dialogue_file = "res://scenes/Dialogue_Lines/giamil_dialogue1.json"):
	if d_active:
		return
	d_active = true
	$NinePatchRect.visible = true 
	dialogue = load_dialogue(dialogue_file)
	current_dialogue_id = -1
	next_script()

func load_dialogue(file_path):
	if not FileAccess.file_exists(file_path):
		print("Dialogue file not found, defaulting to giamil_dialogue1.json")
		file_path = "res://scenes/Dialogue_Lines/giamil_dialogue1.json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		print("Failed to load dialogue file:", file_path)  # Debugging
		return []
	var content = JSON.parse_string(file.get_as_text())
	return content if content != null else []

func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()
		
func next_script():
	current_dialogue_id += 1 
	if current_dialogue_id >= len(dialogue):
		d_active = false 
		$NinePatchRect.visible = false 
		emit_signal("dialogue_finished")
		return

	$NinePatchRect/Name.text = dialogue[current_dialogue_id]['name']
	$NinePatchRect/Text.text = dialogue[current_dialogue_id]['text']

# Function to trigger dialogue for specific guards
func _on_guard_interact(guard_name):
	var dialogue_files = {
		"npc_guard": "res://scenes/Dialogue_Lines/giamil_dialogue1.json",
		"guard1": "res://scenes/Dialogue_Lines/guard1.json",
		"guard2": "res://scenes/Dialogue_Lines/guard2.json",
		"guard3": "res://scenes/Dialogue_Lines/guard3.json"
	}
	var file_path = dialogue_files.get(guard_name, "res://scenes/Dialogue_Lines/giamil_dialogue1.json")
	print("Loading dialogue for:", guard_name, " -> ", file_path)  # Debugging
	start(file_path)
