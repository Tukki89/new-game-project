extends CharacterBody2D

@onready var sprite = $Sprite2D
var player
var direction: Vector2  

func _ready():
	await get_tree().process_frame  # Wait one frame to ensure player exists
	player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	if player:  # Ensure player exists before accessing position
		direction = player.position - position
		sprite.flip_h = direction.x < 0  # Simplified flipping logic
