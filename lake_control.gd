extends Control

const RETURN_SCENE = "res://Lake.tscn"

func _ready() -> void:
	$VideoStreamPlayer.play()
	$VideoStreamPlayer.connect("finished", Callable(self, "_on_cutscene_finished"))

func _on_cutscene_finished():
	print("DEBUG: Cutscene finished, returning to lake")
	get_tree().change_scene_to_file(RETURN_SCENE)  # Return to the lake
