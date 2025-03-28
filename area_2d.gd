extends Node2D

var CUTSCENE_PATH: String = "res://lake_cutsene.tscn"

func _ready():
	ResourceLoader.load_threaded_request(CUTSCENE_PATH)
	
	
