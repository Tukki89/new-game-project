extends Control

const NEXT_SCENE_PATH = "res://Lake.tscn"  # Change this to your next scene

func _ready() -> void:
	$VideoStreamPlayer.connect("finished", Callable(self, "_on_cutscene_finished"))

func _on_cutscene_finished():
	print("DEBUG: Cutscene finished, changing scene to", NEXT_SCENE_PATH)
	get_tree().change_scene_to_file(NEXT_SCENE_PATH)  # Change to the next scene
