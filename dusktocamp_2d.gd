extends Area2D



func _on_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene_to_file("res://Camp.tscn") # Replace with function body.


func _on_collision_shape_2d_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.
