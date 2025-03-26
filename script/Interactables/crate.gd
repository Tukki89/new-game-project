extends StaticBody2D

signal crate_destroyed  # Signal to notify the quest system

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "sword": 
		$anim.play("Destroyed")
		await $anim.animation_finished
		emit_signal("crate_destroyed")  # Notify the quest system
		queue_free()
