extends Node2D
class_name Player_instance

@onready var player_scene = preload("res://scenes/Player/player.tscn")
@onready var spawn_point = $Camp_entry/spawn_point  # Check if this path is correct

func _ready():
	# Ensure spawn happens after all nodes are initialized
	await get_tree().process_frame  

	on_player_spawn()

func on_player_spawn():
	# Check if spawn point exists
	if not spawn_point:
		printerr("Error: Spawn point not found!")
		return

	print("Spawn point position:", spawn_point.global_position)  # Debugging

	var player = player_scene.instantiate()
	player.global_position = spawn_point.global_position  # Ensure correct placement

	add_child(player)

	# Force set the player's position again in case of unwanted offset
	await get_tree().process_frame  
	player.global_position = spawn_point.global_position  

	print("Player spawned at:", player.global_position)  # Debugging
