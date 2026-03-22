extends PlayerState

enum TYPE {SWORDGROUND, SWORDAIR, SWORDCROUCH, PUNCH, RUNPUNCH, KICK}
enum CATEGORY {BASE, ALT, NONE}
var attacks: Dictionary = {
	TYPE.SWORDGROUND: {
		'base': 'Attack',
		'category': CATEGORY.BASE,
		'frames': {
			1: 4,
			2: 6,
			3: 6
		},
		'impactframes': {
			1: [1, 2],
			2: [3, 4],
			3: [2, 3]
		}
	},
	TYPE.SWORDAIR: {
		'base': 'AttackAir',
		'category': CATEGORY.BASE,
		'frames': {
			
		},
		'impactframes': {
			
		}
	},
	TYPE.PUNCH: {
		'base': 'Punch',
		'category': CATEGORY.BASE,
		'frames': {
			1: 4,
			2: 4,
			3: 5
		},
		'impactframes': {
			1: [2,],
			2: [2, 3],
			3: [2,]
		}
	},
	TYPE.RUNPUNCH: {
		'base': 'RunPunch',
		'category': CATEGORY.BASE,
		'frames': {
			1: 7
		},
		'impactframes': {
			1: [3,]
		}
	},
	TYPE.KICK: {
		'base': 'Kick',
		'category': CATEGORY.ALT,
		'frames': {
			1: 4,
			2: 4
		},
		'impactframes': {
			1: [2,],
			2: [1, 2]
		}
	}
}
var attack_phase: int
var attack_type: TYPE
var next_attack: CATEGORY

func enter(previous_state_path: String, data := {}) -> void:
	attack_phase = 1
	attack_type = TYPE.SWORDGROUND
	next_attack = CATEGORY.NONE
	match data['type']:
		'runpunch':
			attack_type = TYPE.RUNPUNCH
		'punch':
			attack_type = TYPE.PUNCH
		'kick':
			attack_type = TYPE.KICK
		'swordground':
			attack_type = TYPE.SWORDGROUND
	
	player.anim_sprite.play(attacks[attack_type]['base'] + str(attack_phase))

func physics_update(delta: float) -> void:
	player.move_and_slide()
	if Input.is_action_just_pressed('attack'):
		next_attack = CATEGORY.BASE
	elif Input.is_action_just_pressed('alt_attack'):
		next_attack = CATEGORY.ALT
	
	continuous_attacks()

func continuous_attacks():
	var final_frame = attacks[attack_type]['frames'][attack_phase]
	if player.anim_sprite.frame + 1 == final_frame:
		if next_attack == CATEGORY.NONE:
			transition()

		elif next_attack == attacks[attack_type]['category']:
			if attack_phase < len(attacks[attack_type]['frames']):
				attack_phase += 1
			else:
				attack_phase = 1
			player.anim_sprite.play(attacks[attack_type]['base'] + str(attack_phase))
			next_attack = CATEGORY.NONE

		else:
			attack_phase = 1
			if next_attack == CATEGORY.ALT:
				if not player.sword_drawn and attack_type != TYPE.RUNPUNCH:
					attack_type = TYPE.KICK
				else:
					transition()
					return
			else:
				if not player.sword_drawn:
					attack_type = TYPE.PUNCH
				else:
					attack_type = TYPE.SWORDGROUND
			player.anim_sprite.play(attacks[attack_type]['base'] + str(attack_phase))

func transition():
	finished.emit(IDLE)
