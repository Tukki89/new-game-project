extends Control  # Now it's attached to the Control node

@export var next_scene: String = "res://scenes/new world.tscn"

func _ready():
	var video_player = $VideoStreamPlayer  # Get the child VideoStreamPlayer node
	video_player.play()  # Start the video
	await video_player.finished  # Wait for the video to finish
	get_tree().change_scene_to_file(next_scene)  # Change to the next scene
