extends Control

signal quest_menu_closed

var quest1_active = false
var quest1_completed = false 
var npcs_talked_to = 0  # Track NPC interactions
const TOTAL_NPCS = 3  # Required NPCs to talk to

func _process(delta):
	if quest1_active and npcs_talked_to >= TOTAL_NPCS:
		print("quest 1 completed")
		quest1_active = false
		quest1_completed = true

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_Q:
		next_quest()

func quest1_chat():
	$quest1_ui.visible = true 

func next_quest():
	if !quest1_completed:
		quest1_chat()
	else:
		$no_quest.visible = true 
		await get_tree().create_timer(3).timeout
		$no_quest.visible = false 

func _on_yes_button_1_pressed(): 
	$quest1_ui.visible = false 
	quest1_active = true 
	npcs_talked_to = 0  # Reset progress
	emit_signal("quest_menu_closed")

func _on_no_button_1_pressed(): 
	$quest1_ui.visible = false 
	quest1_active = false  
	emit_signal("quest_menu_closed")

# Call this function when the player talks to an NPC
func _on_npc_talked():
	if quest1_active and npcs_talked_to < TOTAL_NPCS:
		npcs_talked_to += 1
