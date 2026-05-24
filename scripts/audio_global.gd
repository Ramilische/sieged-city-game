extends Node

var current_location: String # Catacombs, City, Menu
var is_battle: bool
var music_volume: int
var sfx_volume: int

func _ready() -> void:
	current_location = 'Menu'
	is_battle = false
