extends Area2D



func _on_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene_to_file("res://castle_exit.tscn") # Replace with function body
