extends PlayerState


func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	if player.sword_drawn:
		player.anim_sprite.play("IdleSword")
	else:
		player.anim_sprite.play("Idle")

func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
	handle_animations()
	state_change()

func state_change():
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("crouch"):
		finished.emit(CROUCHING)
	elif Input.is_action_just_pressed("draw_sword"):
		player.sword_drawn = false if player.sword_drawn else true
	elif Input.is_action_just_pressed("attack") and player.sword_drawn:
		finished.emit(ATTACK, {'type': 'swordground'})
	elif Input.is_action_just_pressed("attack") and not player.sword_drawn:
		finished.emit(ATTACK, {'type': 'punch'})
	elif Input.is_action_just_pressed("alt_attack") and not player.sword_drawn:
		finished.emit(ATTACK, {'type': 'kick'})
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	elif Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
		pass
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		finished.emit(RUNNING)

func handle_animations():
	var anim = player.anim_sprite
	
	# Меч
	if player.sword_drawn and anim.animation == "Idle":
		anim.play("DrawSword")
	elif not player.sword_drawn and anim.animation == "IdleSword":
		anim.play("SheatheSword")
	elif anim.animation == "DrawSword" and anim.frame == 3:
		anim.play("IdleSword")
	elif anim.animation == "SheatheSword" and anim.frame == 3:
		anim.play("Idle")
