class_name Inventory
extends RefCounted

var items: Array[Item]
var equip: Dictionary[String, Equipment]
var default_equip: Dictionary[String, Equipment] = {
	'Head': Equipment.new(Equipment.Type.HEAD, 'Army helmet', 3000, 10)
}

func _init() -> void:
	items = []
	equip = {}
	var apple = Item.new('Apple', 10, 1)
	items.append(apple)
	equip.assign(default_equip)

func print() -> void:
	print(items)
	print(equip)
