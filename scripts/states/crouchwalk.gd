extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.anim_sprite.play("CrouchWalk")

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	
	player.velocity.x = player.crouch_speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	state_change(input_direction_x)
	flipping(input_direction_x)

func state_change(direction: float):
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("crouch"):
		finished.emit(RUNNING)
	elif is_equal_approx(direction, 0.0):
		finished.emit(CROUCHING)

func flipping(direction: float):
	if direction == 0:
		pass
	elif not player.is_flipped and direction < 0:
		player.apply_scale(Vector2(-1, 1))
		player.is_flipped = true
	elif player.is_flipped and direction > 0:
		player.apply_scale(Vector2(-1, 1))
		player.is_flipped = false
