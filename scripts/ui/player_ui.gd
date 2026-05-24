extends CanvasLayer

@export var player: Player

@onready var stats = $Stats
@onready var inventory = $Inventory
@onready var dim = $Dim
@onready var hp_label = $Stats/HP
@onready var level_label = $Stats/Level
@onready var settings: Control = $Settings

var inventory_open: bool
var settings_open: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.stats.health_change.connect(set_labels)
	player.stats.xp_change.connect(set_labels)
	set_labels()
	inventory_open = false
	settings_open = false
	set_visibility()
	AudioGlobal.current_location = 'Menu'


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		if settings_open:
			settings_open = false
		inventory_open = not inventory_open
		player.processing_movement_input = not inventory_open
		set_visibility()
	if Input.is_action_just_pressed("menu"):
		if inventory_open:
			inventory_open = false
		settings_open = not settings_open
		player.processing_movement_input = not settings_open
		set_visibility()
		


func set_visibility() -> void:
	stats.visible = not inventory_open
	dim.visible = inventory_open or settings_open
	inventory.visible = inventory_open
	settings.visible = settings_open
	if inventory.visible:
		draw_inventory()

func set_labels():
	hp_label.text = 'Здоровье: ' + str(player.stats.health)
	level_label.text = 'Уровень: ' + str(player.stats.level)

func draw_inventory() -> void:
	pass
