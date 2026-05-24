extends Node

var current_location: String # Catacombs, City, Menu
var is_battle: bool
var music_volume: int
var sfx_volume: int

func _ready() -> void:
	is_battle = false
