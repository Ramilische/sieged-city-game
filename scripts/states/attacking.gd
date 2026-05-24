extends PlayerState

enum TYPE {SWORDGROUND, SWORDAIR, SWORDCROUCH, PUNCH, RUNPUNCH, KICK, NONE}
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
		},
		'collision_areas': {
			1: 'SwordAttack1',
			2: 'SwordAttack2',
			3: 'SwordAttack3',
		},
		'damage': {
			1: 20,
			2: 25,
			3: 25
		},
		'is_weapon': true
	},
	TYPE.SWORDAIR: {
		'base': 'AttackAir',
		'category': CATEGORY.BASE,
		'frames': {
			
		},
		'impactframes': {
			
		},
		'is_weapon': true
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
		},
		'collision_areas': {
			1: 'PunchAttack1',
			2: 'PunchAttack2',
			3: 'PunchAttack3',
		},
		'damage': {
			1: 8,
			2: 10,
			3: 12
		},
		'is_weapon': false
	},
	TYPE.RUNPUNCH: {
		'base': 'RunPunch',
		'category': CATEGORY.BASE,
		'frames': {
			1: 7
		},
		'impactframes': {
			1: [3,]
		},
		'collision_areas': {
			1: 'RunPunchAttack'
		},
		'damage': {
			1: 20
		},
		'is_weapon': false
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
		},
		'collision_areas': {
			1: 'KickAttack1',
			2: 'KickAttack2'
		},
		'damage': {
			1: 10,
			2: 15
		},
		'is_weapon': false
	}
}
var attack_phase: int = 0
var attack_type: TYPE = TYPE.NONE
var next_attack: CATEGORY = CATEGORY.NONE
var already_damaged: bool = false
var frame: int = -1
var final_frame: int = -1
var last_sound = 0
var is_impact_frame: bool = false


func enter(previous_state_path: String, data := {}) -> void:
	attack_phase = 1
	attack_type = TYPE.NONE
	next_attack = CATEGORY.NONE
	already_damaged = false
	frame = 1
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

	is_impact_frame = frame in attacks[attack_type]['impactframes'][attack_phase]
	var hitbox_name: String = attacks[attack_type]['collision_areas'][attack_phase]
	var area: Area2D = player.hitboxes_node.find_child(hitbox_name)
	if frame == attacks[attack_type]['impactframes'][attack_phase][0] and frame != last_sound:
		last_sound = frame
		area.monitoring = true
		player.play_attack_sound(attack_phase, attacks[attack_type]['base'])
	else:
		area.monitoring = false
	
	player_control()
	continuous_attacks()

func player_control():
	if player.processing_movement_input == false:
		pass
	elif Input.is_action_just_pressed('attack'):
		next_attack = CATEGORY.BASE
	elif Input.is_action_just_pressed('alt_attack'):
		next_attack = CATEGORY.ALT

func continuous_attacks():
	frame = player.anim_sprite.frame
	final_frame = attacks[attack_type]['frames'][attack_phase]
	if frame + 1 == final_frame:
		last_sound = 0
		if next_attack == CATEGORY.NONE:
			transition()

		elif next_attack == attacks[attack_type]['category']:
			already_damaged = false
			if attack_phase < len(attacks[attack_type]['frames']):
				attack_phase += 1
			else:
				attack_phase = 1
			player.anim_sprite.play(attacks[attack_type]['base'] + str(attack_phase))
			next_attack = CATEGORY.NONE

		else:
			attack_phase = 1
			already_damaged = false
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


func _on_body_entered(body: Node2D) -> void:
	var checks: Array[bool] = [body is Enemy, not already_damaged, attack_phase > 0]
	for ch in checks:
		if not ch:
			return
	var attack = attacks[attack_type]
	body.stats.take_damage(player.stats.damage(attack['damage'][attack_phase], attack['is_weapon']))
	already_damaged = true
