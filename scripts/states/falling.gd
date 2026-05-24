extends PlayerState

var buffered_jump

func enter(previous_state_path: String, data := {}) -> void:
	player.anim_sprite.play("Fall")
	if player.jump_buffering:
		buffered_jump = false
	if player.coyote_time and previous_state_path==RUNNING:
		player.coyote_timer.start()

func physics_update(delta: float) -> void:
	var input_direction_x = 0
	if player.processing_movement_input:
		input_direction_x = Input.get_axis("move_left", "move_right")
		if player.coyote_time:
			coyote()
		if player.jump_buffering:
			jumpbuffer()
		flipping(input_direction_x)
		godmode()
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	state_change(input_direction_x)

func state_change(direction):
	if player.is_on_floor():
		if buffered_jump:
			buffered_jump = false
			finished.emit(JUMPING)
		elif is_equal_approx(direction, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)

func flipping(direction: float):
	if not player.is_flipped and direction < 0:
		player.apply_scale(Vector2(-1, 1))
		player.is_flipped = true
	elif player.is_flipped and direction > 0:
		player.apply_scale(Vector2(-1, 1))
		player.is_flipped = false

func coyote():
	if Input.is_action_just_pressed("jump") and not player.coyote_timer.is_stopped():
		player.coyote_timer.stop()
		finished.emit(JUMPING)

func jumpbuffer():
	if Input.is_action_just_pressed("jump") and player.jump_buffering_timer.is_stopped():
		player.jump_buffering_timer.start()
		buffered_jump = true

func godmode():
	if player.double_jump and Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)

func _on_coyote_timer_timeout() -> void:
	player.coyote_timer.stop()

func _on_jump_buffering_timer_timeout() -> void:
	buffered_jump = false
	player.jump_buffering_timer.stop()
