extends VideoStreamPlayer

func _ready():
	finished.connect(_on_video_finished)  # Ensure connection

func _on_video_finished():
	print("Cutscene 2 finished, changing to gameplay...")  # Debugging print
	stop()
	get_tree().change_scene_to_file("res://scenes/new world.tscn")  # Ensure correct path


func _on_finished() -> void:
	pass # Replace with function body.
