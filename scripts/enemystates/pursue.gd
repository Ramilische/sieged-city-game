extends EnemyState

@onready var player_lost_timer: Timer = $"../../PlayerLostTimer"
var spotted_player: bool
var distance: float
var direction: int
var player: Player

func enter(previous_state_path: String, data := {}) -> void:
	enemy.anim_sprite.play('Run')
	enemy.stats.dead.connect(_on_death)
	spotted_player = true
	direction = data['dir']
	player = data['player']
	flipping(direction)
	if 'attack' not in previous_state_path.to_lower():
		player.change_pursuing_enemies(1)
	print(player.pursuing_enemies)

func physics_update(_delta: float) -> void:
	enemy.velocity.y += enemy.gravity * _delta
	enemy.velocity.x += enemy.acceleration * _delta * direction
	enemy.velocity.x = min(abs(enemy.velocity.x), abs(enemy.pursue_speed)) * direction
	enemy.move_and_slide()
	distance = abs(enemy.position.x - player.position.x);
	direction = -1 if enemy.position.x > player.position.x else 1
	
	flipping(direction)
	handle_animations()
	look_for_player()
	state_change()
	

func look_for_player():
	var target: Player
	for ray: RayCast2D in enemy.rays.get_children():
		if ray.is_colliding() and ray.get_collider() is Player:
			target = ray.get_collider()
			break
	spotted_player = target != null

func state_change():
	if distance <= enemy.attack_distance:
		finished.emit(ATTACK, {'dir': direction, 'player': player})
	if not spotted_player and player_lost_timer.is_stopped():
		print('Losing the player')
		player_lost_timer.start(enemy.pursue_losing_time)
	elif spotted_player and not player_lost_timer.is_stopped():
		print('Found the player again')
		player_lost_timer.stop()

func handle_animations():
	pass

func flipping(direction: float):
	if not enemy.is_flipped and direction < 0:
		enemy.pivot.apply_scale(Vector2(-1, 1))
		enemy.is_flipped = true
		enemy.anim_sprite.flip_h = enemy.is_flipped
	elif enemy.is_flipped and direction > 0:
		enemy.pivot.apply_scale(Vector2(-1, 1))
		enemy.is_flipped = false
		enemy.anim_sprite.flip_h = enemy.is_flipped

func _on_player_lost_timer_timeout() -> void:
	player_lost_timer.stop()
	print('Lost the player')
	player.change_pursuing_enemies(-1)
	finished.emit(RETURN)

func _on_death():
	print('Enemy died')
	player.change_pursuing_enemies(-1)
	print(player.pursuing_enemies)
