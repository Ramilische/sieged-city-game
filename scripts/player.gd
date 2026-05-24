class_name Player extends CharacterBody2D

@export var speed: float = 200.0
@export var acceleration: float = 40.0
@export var deceleration: float = 50.0
@export var crouch_speed: float = 100.0
@export var jump_impulse: float = 300.0
@export var push_force: float = 100
@export var gravity: float = 980.0
@export var jump_buffering: bool = true
@export var coyote_time: bool = true

var processing_movement_input: bool = true
var is_running: bool = false
var sword_drawn: bool = false
var is_flipped: bool = false
var godmode: bool = false
var double_jump: bool = false
var normal_speed: float = speed
var speed_boost: float = 2.0
var pursuing_enemies: int = 0

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitboxes_node = $Hitboxes
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffering_timer: Timer = $JumpBufferingTimer
@onready var stats = HeroLogic.new()

var footsteps = [
	preload("res://assets/audio/sfx/steps/step1.wav"),
	preload("res://assets/audio/sfx/steps/step2.wav"),
	preload("res://assets/audio/sfx/steps/step3.wav"),
	preload("res://assets/audio/sfx/steps/step4.wav"),
	preload("res://assets/audio/sfx/steps/step5.wav"),
]
var swooshes = [
	preload('res://assets/audio/sfx/attacks/1.mp3'),
	preload('res://assets/audio/sfx/attacks/2.mp3'),
	preload('res://assets/audio/sfx/attacks/3.mp3'),
	preload('res://assets/audio/sfx/attacks/4.mp3'),
	preload('res://assets/audio/sfx/attacks/5.mp3'),
	preload('res://assets/audio/sfx/attacks/6.mp3'),
	preload('res://assets/audio/sfx/attacks/7.mp3'),
	preload('res://assets/audio/sfx/attacks/8.mp3'),
	preload('res://assets/audio/sfx/attacks/9.mp3'),
	preload('res://assets/audio/sfx/attacks/10.mp3')
]
var attacks = {
	'Attack': [
		preload("res://assets/audio/sfx/attacks/Attack1.wav"), 
		preload("res://assets/audio/sfx/attacks/Attack2.wav"), 
		preload("res://assets/audio/sfx/attacks/Attack3.wav")],
	'Kick': swooshes,
	'Punch': swooshes,
	'RunPunch': swooshes
}


func _ready() -> void:
	stats.dead.connect(death)
	print(AudioGlobal.current_location)
	print(WorldAudioManager.current_location)

func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("menu"):
		#get_tree().quit()
	if Input.is_action_just_pressed("godmode"):
		godmode = not godmode
		if godmode:
			double_jump = true
			speed = normal_speed * speed_boost
		else:
			double_jump = false
			speed = normal_speed
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		var obj = c.get_collider()
		if obj is RigidBody2D:
			obj.apply_central_impulse(-c.get_normal() * push_force)

func death():
	get_tree().change_scene_to_file("res://scenes/interface/mainmenu.tscn")


func play_footsteps(muffled: bool = false):
	var audio_player = AudioStreamPlayer2D.new()
	if muffled:
		audio_player.volume_db -= 5
	audio_player.stream = footsteps.pick_random()
	audio_player.bus = 'SFX'
	get_tree().root.add_child(audio_player)
	audio_player.global_position = position
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()

func play_attack_sound(phase, name):
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.stream = attacks[name].pick_random()
	audio_player.bus = 'SFX'
	get_tree().root.add_child(audio_player)
	audio_player.global_position = position
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()

func change_pursuing_enemies(amount: int):
	pursuing_enemies += amount
	if pursuing_enemies <= 0:
		pursuing_enemies = 0
		AudioGlobal.is_battle = false
	else:
		AudioGlobal.is_battle = true
		
