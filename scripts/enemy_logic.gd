class_name EnemyLogic
extends RefCounted


var enemy_damage: int
var enemy_health: int
var enemy_xp_worth: int

signal dead(dropped_xp: int)
signal health_change()


func _init(new_health: int, new_damage: int, new_xp_worth: int) -> void:
	enemy_health = new_health
	enemy_damage = new_damage
	enemy_xp_worth = new_xp_worth

func take_damage(damage: int):
	enemy_health = max(enemy_health - damage, 0)
	health_change.emit()
	if enemy_health <= 0:
		death()

func death():
	print('sending signal of enemy death')
	dead.emit()
