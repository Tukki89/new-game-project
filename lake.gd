extends Node2D

var CUTSCENE_PATH: String = "res://lake_cutscene.tscn"
var triggered: bool = false  # Ensures cutscene plays only once

func _ready():
	ResourceLoader.load_threaded_request(CUTSCENE_PATH)
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	var cutscene = ResourceLoader.load_threaded_get(CUTSCENE_PATH)
	get_tree().change_scene_to_packed.call_deferred(cutscene)
