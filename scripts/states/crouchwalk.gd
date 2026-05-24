extends PlayerState

var last_step: int = 0

func enter(previous_state_path: String, data := {}) -> void:
	player.anim_sprite.play("CrouchWalk")

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	
	player.velocity.x = player.crouch_speed * input_direction_x
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if player.anim_sprite.frame in [2, 5] and player.anim_sprite.frame != last_step:
		last_step = player.anim_sprite.frame
		player.play_footsteps(true)
	
	state_change(input_direction_x)
	flipping(input_direction_x)

func state_change(direction: float):
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif is_equal_approx(direction, 0.0):
		finished.emit(CROUCHING)
	elif Input.is_action_just_pressed("crouch") and player.processing_movement_input:
		finished.emit(RUNNING)

func flipping(direction: float):
	if direction == 0:
		pass
	elif not player.is_flipped and direction < 0:
		player.apply_scale(Vector2(-1, 1))
		player.is_flipped = true
	elif player.is_flipped and direction > 0:
		player.apply_scale(Vector2(-1, 1))
		player.is_flipped = false
