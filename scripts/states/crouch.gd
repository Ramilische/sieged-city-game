extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	player.anim_sprite.play("Crouch")

func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
	handle_animations()
	state_change()

func state_change():
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("crouch"):
		finished.emit(IDLE)
	elif Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
		pass
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		finished.emit(CROUCHWALKING)

func handle_animations():
	pass
