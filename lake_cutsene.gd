extends Control
var next_scene = preload("res://lake_cutsene.tscn")



func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_packed(next_scene)
