extends Node


const scene_Camp = preload("res://Camp.tscn")
const scene_Duskwither_Hollow = preload("res://Duskwither_Hollow.tscn")

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load 
	
	match level_tag:
		"Camp":
			scene_to_load = scene_Camp
		"Duskwither_Hollow":
			scene_to_load = scene_Duskwither_Hollow
			
	if scene_to_load != null: 
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)
