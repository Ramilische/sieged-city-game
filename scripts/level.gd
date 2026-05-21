class_name Level
extends Node2D

var enemies: Array[Node2D]
var npc: Array[Node2D]


func _init() -> void:
	# Здесь надо будет заполнять список врагов, забирая их из БД
	#  и подгружать все остальное
	pass

func _physics_process(delta: float) -> void:
	# Здесь надо будет обрабатывать поведение всех врагов и нпс сразу
	#  если кто-то мертв, то удалять его из списка
	pass

func _exit_tree() -> void:
	# Здесь надо будет обновлять БД со всеми врагами и нпс если произошли изменения
	pass
