extends CanvasLayer

@export var player: Node

@onready var hp_label = $TopLeft/HP
@onready var level_label = $TopLeft/Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Здесь я рассчитываю на то, что Node статистики всегда будет стоять первым в очереди Player
	#  возможно что find_child был бы более подходящим методом
	hp_label.text = 'Здоровье: ' + str(player.stats.health)
	level_label.text = 'Уровень: ' + str(player.stats.level)
