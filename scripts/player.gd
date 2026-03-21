class_name Player extends CharacterBody2D

@export var speed = 200.0
@export var jump_impulse = 300.0
@export var gravity = 980.0

var curr_state
var is_running = false
var sword_drawn = false
var is_flipped = false

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
