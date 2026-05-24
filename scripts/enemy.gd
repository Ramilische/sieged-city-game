class_name Enemy extends CharacterBody2D

@export var patrol_speed: float = 2000.0
@export var pursue_speed: float = 4000.0
@export var acceleration: float = 40.0
@export var deceleration: float = 50.0
@export var jump_impulse: float = 300.0
@export var gravity: float = 980.0
@export var attack_distance: float = 25.0

@export var patrol_stand_time: float = 5.0
@export var patrol_x_reach: float = 100.0
@export var patrol_vision_angle: float = 60.0
@export var patrol_step_between_rays: float = 3.0

@export var pursue_losing_time: float = 5.0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var stats: EnemyLogic = EnemyLogic.new(50, 20, 10)
@onready var state_machine: StateMachine = $"State Machine"
@onready var pivot: Node2D
@onready var rays: Node2D
@onready var hit_area: Area2D

var patrol_center_x: float
var angle_cone_of_vision: float = deg_to_rad(patrol_vision_angle)
var max_view_distance: float = 400.0
var view_distance_multiplier: float = 2
var step_between_rays: float = deg_to_rad(patrol_step_between_rays)
var is_flipped: bool = false


func _ready() -> void:
	pivot = self.find_child('Pivot')
	rays = pivot.find_child('Rays')
	hit_area = pivot.find_child('Hit Area')
	hit_area.monitoring = false
	patrol_center_x = position.x
	generate_raycasts()
	stats.dead.connect(death)

func generate_raycasts() -> void:
	var ray_count := angle_cone_of_vision / step_between_rays
	for i in range(ray_count):
		var ray: RayCast2D = RayCast2D.new()
		var angle = step_between_rays * (i - ray_count / 2.0)
		ray.look_at(Vector2.UP.rotated(angle) * max_view_distance)
		find_child('Rays').add_child(ray)
		ray.target_position *= view_distance_multiplier
		ray.enabled = true

func death():
	anim_sprite.play('Death')
	queue_free()
