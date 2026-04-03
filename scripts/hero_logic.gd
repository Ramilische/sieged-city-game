class_name HeroLogic
extends RefCounted

@export var health: int = 100
@export var max_health: int = 100
@export var level: int = 1
@export var xp: int = 0
var xp_to_next_level: int

const level_cap: int = 20
const xp_to_level_up: Dictionary = {
	1: 100,
	2: 200,
	3: 300,
	4: 400,
	5: 500,
	6: 600,
	7: 700,
	8: 800,
	9: 900,
	10: 1000,
	11: 1100,
	12: 1200,
	13: 1300,
	14: 1400,
	15: 1500,
	16: 1600,
	17: 1700,
	18: 1800,
	19: 1900
}

func _init() -> void:
	xp_to_next_level = xp_to_level_up[level] - xp
	# Здесь должна быть подгрузка статов из выбранного файла сохранения
	pass

func serialize() -> Dictionary:
	var res: Dictionary = {
		'health': health,
		'max_health': max_health,
		'level': level,
		'xp': xp,
		'xp_to_level_up': xp_to_level_up
	}
	return res

func save_progress(save_number: int) -> void:
	# Скорее всего сохранения придется переработать, т.к. пока сохраняются
	# только статы игрока. Посмотреть:
	# https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html

	var path = 'user://autosave.save'
	if save_number != 0: # если номер сохранения 0, то это автосохранение
		path = 'user://save_%s.save' % save_number

	var file = FileAccess.open(path, FileAccess.WRITE)
	var data = JSON.stringify(serialize())
	file.store_line(data)
	

func load_progress(save_number: int) -> void:
	# Скорее всего сохранения придется переработать, т.к. пока сохраняются
	# только статы игрока. Посмотреть:
	# https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html

	pass
