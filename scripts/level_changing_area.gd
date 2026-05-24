extends Area2D

@export var cshape_x: float
@export var cshape_y: float
@export var new_scene_file_path: String

@onready var collision: CollisionShape2D = $CollisionShape2D
var collision_shape: RectangleShape2D
var can_teleport: bool = false

func _ready() -> void:
	collision_shape = collision.shape
	collision_shape.size = Vector2(cshape_x, cshape_y)

func _process(delta: float) -> void:
	if can_teleport:
		if Input.is_action_just_pressed('action'):
			get_tree().change_scene_to_file(new_scene_file_path)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		can_teleport = true
		body.prompt_scene_change()
