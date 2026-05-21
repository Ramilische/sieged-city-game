class_name HeroLogic
extends RefCounted

@export var health: int = 100
@export var max_health: int = 100
@export var level: int = 1
@export var xp: int = 0
@export var damage_modifier: float = 1.0
@export var damage_modifier_unarmed: float = 1.0
var xp_to_next_level: int

var inventory: Inventory

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

signal dead()
signal health_change()
signal xp_change()


func _init() -> void:
	xp_to_next_level = xp_to_level_up[level] - xp
	inventory = Inventory.new()
	inventory.print()
	# Здесь должна быть подгрузка статов из выбранного файла сохранения
	pass

func take_damage(dmg: int) -> void:
	health -= min(dmg, health)
	health_change.emit()
	if health <= 0:
		death()

func earn_xp(new_xp: int):
	xp += new_xp
	while xp >= xp_to_level_up[level]:
		xp -= xp_to_level_up[level]
		level += 1
	xp_change.emit()

func damage(base_damage: int, is_weapon: bool) -> int:
	if is_weapon:
		return round(base_damage * damage_modifier)
	else:
		return round(base_damage * damage_modifier_unarmed)

func death() -> void:
	dead.emit()


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
	# Посмотреть:
	# https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
	pass

func load_progress(save_number: int) -> void:
	pass
