extends VideoStreamPlayer

func _ready():
	connect("finished", Callable(self, "_on_video_finished"))

func _on_video_finished():
	stop()  # Stops the video
	get_tree().change_scene_to_file("res://next_scene.tscn")  # Change scene


func _on_finished() -> void:
	pass # Replace with function body.
