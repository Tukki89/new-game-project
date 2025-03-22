extends CanvasLayer

const HEART_ROW_SIZE = 8 
const HEART_OFFSET = 16
const REGEN_TIME = 5.0  # Time in seconds before regeneration

var regen_timer = 0.0  # Tracks time since last damage

func _ready() -> void:
	for i in range(Player_data.player_health):  # Use initial player health
		var new_heart = Sprite2D.new()
		new_heart.texture = $heart.texture 
		new_heart.hframes = $heart.hframes
		$heart.add_child(new_heart)

func _process(delta):
	regen_timer += delta
	
	# Regenerate if 5 seconds have passed and health is not full
	if regen_timer >= REGEN_TIME and Player_data.player_health < 16:  # Hardcoded 16 as the max health
		Player_data.player_health += 1
		regen_timer = 0  # Reset timer

	# Update heart display
	for heart in $heart.get_children():
		var index = heart.get_index()
		var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = (index / HEART_ROW_SIZE) * HEART_OFFSET
		heart.position = Vector2(x, y)
		
		var last_heart = floor(Player_data.player_health) 
		if index > last_heart:  
			heart.frame = 0 
		if index == last_heart:
			heart.frame = (Player_data.player_health - last_heart) * 4
		if index < last_heart:
			heart.frame = 4

# Call this function whenever the player takes damage
func on_player_hit():
	Player_data.player_health -= 1  # Adjust based on your damage logic
	regen_timer = 0  # Reset regeneration timer
