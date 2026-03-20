class_name Player extends CharacterBody2D

@export var SPEED = 200.0
@export var JUMP_VELOCITY = -300.0
@export var gravity = 980.0

var curr_state
var is_running = false
var sword_drawn = false
var is_flipped = false

@onready var anim_sprite = $AnimatedSprite2D


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	print(velocity.x)
	if abs(velocity.x) and not is_running:
		anim_sprite.play("Run")
		is_running = true
	elif abs(velocity.x) == 0 and is_running:
		is_running = false
		if sword_drawn:
			anim_sprite.play("IdleSword")
		else:
			anim_sprite.play("Idle")
	if velocity.x < 0 and not is_flipped:
		is_flipped = true
		anim_sprite.flip_h = is_flipped
	elif velocity.x > 0 and is_flipped:
		is_flipped = false
		anim_sprite.flip_h = is_flipped


func _physics_process(delta: float) -> void:
	gravity_handler(delta)
	jump_handler()
	horizontal_movement_handler()

	move_and_slide()

func gravity_handler(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

func jump_handler():
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func horizontal_movement_handler():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func change_global_timescale(timescale_value: float = 0.5) -> void:
	if timescale_value <= 0.0:
		return
	Engine.time_scale = timescale_value
