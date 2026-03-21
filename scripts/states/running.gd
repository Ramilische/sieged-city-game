extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.anim_sprite.play("Run")

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif is_equal_approx(input_direction_x, 0.0):
		finished.emit(IDLE)
	
	if not player.is_flipped and input_direction_x < 0:
		player.apply_scale(Vector2(-1, 1))
		player.is_flipped = true
	elif player.is_flipped and input_direction_x > 0:
		player.apply_scale(Vector2(-1, 1))
		player.is_flipped = false
