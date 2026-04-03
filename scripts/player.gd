class_name Player extends CharacterBody2D

@export var speed: float = 200.0
@export var acceleration: float = 40.0
@export var deceleration: float = 50.0
@export var crouch_speed: float = 100.0
@export var jump_impulse: float = 300.0
@export var gravity: float = 980.0
@export var jump_buffering: bool = true
@export var coyote_time: bool = true

var curr_state
var is_running: bool = false
var sword_drawn: bool = false
var is_flipped: bool = false
var godmode: bool = false
var double_jump: bool = false
var normal_speed: float = speed
var speed_boost: float = 2.0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffering_timer: Timer = $JumpBufferingTimer
@onready var stats = HeroLogic.new()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()
	if Input.is_action_just_pressed("godmode"):
		godmode = not godmode
		if godmode:
			double_jump = true
			speed = normal_speed * speed_boost
		else:
			double_jump = false
			speed = normal_speed
