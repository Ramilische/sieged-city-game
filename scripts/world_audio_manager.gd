extends Node

@export var bg_music_player: AudioStreamPlayer
var current_location: String
var is_battle: bool

func _ready() -> void:
	current_location = AudioGlobal.current_location

func _process(delta: float) -> void:
	update_volume()
	if current_location != AudioGlobal.current_location:
		current_location = AudioGlobal.current_location
		is_battle = false
		AudioGlobal.is_battle = false
		update_music()
	elif is_battle != AudioGlobal.is_battle:
		is_battle = AudioGlobal.is_battle
		update_music()

func update_music():
	var current_music: String
	if is_battle:
		current_music = 'BattleMusic'
	else:
		current_music = str(current_location + 'Music')
	bg_music_player['parameters/switch_to_clip'] = current_music

func update_volume():
	var bgmusic_index = AudioServer.get_bus_index("Music")
	var sfx_index = AudioServer.get_bus_index("SFX")
	
	AudioServer.set_bus_volume_db(bgmusic_index, AudioGlobal.music_volume)
	AudioServer.set_bus_volume_db(sfx_index, AudioGlobal.sfx_volume)
