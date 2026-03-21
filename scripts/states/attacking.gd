extends PlayerState

enum TYPE {GROUND, AERIAL, CROUCH}
var attacks: Dictionary = {
	TYPE.GROUND: {
		'base': 'Attack',
		'frames': {
			1: 4,
			2: 6,
			3: 6
		}
	}
}
var attack_phase: int
var attack_type: TYPE
var next_attack: bool

func enter(previous_state_path: String, data := {}) -> void:
	attack_phase = 1
	next_attack = false
	if player.is_on_floor():
		attack_type = TYPE.GROUND
		player.anim_sprite.play('Attack1')

func physics_update(delta: float) -> void:
	player.move_and_slide()
	if Input.is_action_just_pressed('attack'):
		next_attack = true
	
	var final_frame = attacks[attack_type]['frames'][attack_phase]
	if player.anim_sprite.frame + 1 == final_frame:
		if next_attack:
			if attack_phase < len(attacks[attack_type]['frames']):
				attack_phase += 1
			else:
				attack_phase = 1
			player.anim_sprite.play(attacks[attack_type]['base'] + str(attack_phase))
			next_attack = false
		else:
			transition()

func transition():
	finished.emit(IDLE)
