extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  

var is_chatting = false  

func _ready():
	animated_sprite.play("Idle")  
	print("NPC is ready. Chatting:", is_chatting)  

func _process(delta):
	if Input.is_action_just_pressed("chat"):
		if is_chatting:
			print("Already chatting with NPC")
			$Dialogue.start()
		else:
			print("Chat triggered!")  
			is_chatting = true  
			animated_sprite.play("Talk")  
			print("Chatting:", is_chatting)  

func _on_chat_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		print("Player entered chat zone")

func _on_chat_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		print("Player exited chat zone")

# Triggered when the dialogue finishes
func _on_dialogue_dialogue_finished():
	is_chatting = false  # Reset chat state
	animated_sprite.play("Idle")  # Return to idle animation
	print("Dialogue finished. Chatting:", is_chatting)
