extends Control

@onready var music_volume = $CenterContainer/VBoxContainer/MusicScrollbar
@onready var sfx_volume = $CenterContainer/VBoxContainer/SFXScrollbar

func _process(delta: float) -> void:
	volume_update()

func volume_update():
	AudioGlobal.music_volume = music_volume.value
	AudioGlobal.sfx_volume = sfx_volume.value
