class_name Equipment
extends Item

enum Type {
	HEAD,
	TORSO,
	SHOES,
	MELEEWEAPON,
	RANGEDWEAPON,
	ACCESSORIES
}

@export var type: Type


func _init(new_type: Type, new_name: String = 'noname', new_cost: int = 0, new_weight: int = 0) -> void:
	super(new_name, new_cost, new_weight)
	type = new_type

func _to_string() -> String:
	return name + '. Type: ' + str(type) + '. Cost: ' + str(cost) + '. Weight: ' + str(weight)
