extends Control

# Здесь будут просто переходы между окнами

func _on_button_pressed() -> void:
	AudioGlobal.current_location = 'City'
	get_tree().change_scene_to_file("res://scenes/levels/level_3.tscn")
