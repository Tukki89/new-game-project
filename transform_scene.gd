extends Area2D

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

	var cutscene_control = $Control  # Change to match your node name
	if cutscene_control is Control:
		cutscene_control.hide()  # Hide the cutscene initially
	else:
		print("ERROR: Control is missing or not a Control node!")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("DEBUG: Player entered Detector, playing cutscene")
		play_cutscene()

func play_cutscene():
	var cutscene_control = $Control  # Change to match your node name
	if cutscene_control is Control:
		cutscene_control.show()
		cutscene_control.play_video()
	else:
		print("ERROR: Control not found or incorrect type")
