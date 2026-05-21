extends CanvasLayer

@export var player: Player

@onready var stats = $Stats
@onready var inventory = $Inventory
@onready var dim = $Dim
@onready var hp_label = $Stats/HP
@onready var level_label = $Stats/Level

var inventory_open: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.stats.health_change.connect(set_labels)
	player.stats.xp_change.connect(set_labels)
	set_labels()
	inventory_open = false
	set_visibility()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		inventory_open = not inventory_open
		set_visibility()


func set_visibility() -> void:
	stats.visible = not inventory_open
	dim.visible = inventory_open
	inventory.visible = inventory_open
	if inventory.visible:
		draw_inventory()

func set_labels():
	hp_label.text = 'Здоровье: ' + str(player.stats.health)
	level_label.text = 'Уровень: ' + str(player.stats.level)

func draw_inventory() -> void:
	pass
