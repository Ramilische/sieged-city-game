class_name Item
extends RefCounted

@export var icon: Image
@export var name: String
@export var cost: int
@export var weight: int

func _init(new_name: String = 'noname', new_cost: int = 0, new_weight: int = 0) -> void:
	cost = new_cost
	if new_cost < 0:
		cost = 0
	weight = new_weight
	if new_weight < 0:
		weight = 0
	name = new_name

func _to_string() -> String:
	return name + '. Cost: ' + str(cost) + '. Weight: ' + str(weight)
