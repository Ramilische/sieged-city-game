extends PlayerState

var last_step: int = 0

func enter(previous_state_path: String, data := {}) -> void:
	if player.sword_drawn:
		player.anim_sprite.play("RunSword")
	else:
		player.anim_sprite.play("Run")

func physics_update(delta: float) -> void:
	var input_direction_x = 0.0
	if player.processing_movement_input:
		input_direction_x = Input.get_axis("move_left", "move_right")
	
	acceleration(input_direction_x)
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	if player.anim_sprite.frame in [1, 4] and player.anim_sprite.frame != last_step:
		last_step = player.anim_sprite.frame
		player.play_footsteps()

	state_change(input_direction_x)
	flipping(input_direction_x)

func state_change(direction: float):
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif is_equal_approx(direction, 0.0):
		finished.emit(IDLE)
	elif player.processing_movement_input == false:
		pass
	elif Input.is_action_just_pressed("crouch"):
		finished.emit(CROUCHWALKING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif Input.is_action_just_pressed("attack") and not player.sword_drawn:
		finished.emit(ATTACK, {'type': 'runpunch'})
	elif Input.is_action_just_pressed("attack") and player.sword_drawn:
		player.velocity.x = 0
		finished.emit(ATTACK, {'type': 'swordground'})

func acceleration(direction: float):
	var curr = player.velocity.x
	if is_equal_approx(direction, 0.0):
		player.velocity.x = move_toward(curr, 0.0, player.deceleration)
	else:
		player.velocity.x = move_toward(curr, player.speed * direction, player.acceleration)

func flipping(direction: float):
	if direction == 0:
		pass
	elif not player.is_flipped and direction < 0:
		player.apply_scale(Vector2(-1, 1))
		player.is_flipped = true
	elif player.is_flipped and direction > 0:
		player.apply_scale(Vector2(-1, 1))
		player.is_flipped = false
