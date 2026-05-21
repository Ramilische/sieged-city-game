extends EnemyState

var distance: float
var direction: int
var player: Player

func enter(previous_state_path: String, data := {}) -> void:
	direction = data['dir']
	player = data['player']

	enemy.anim_sprite.play('Attack')

func physics_update(_delta: float) -> void:
	enemy.velocity.y += enemy.gravity * _delta
	enemy.velocity.x = 0
	enemy.move_and_slide()
	distance = abs(enemy.position.x - player.position.x);
	direction = -1 if enemy.position.x >= player.position.x else 1
	attack()
	flipping(direction)
	handle_animations()
	state_change()

func state_change():
	if distance > enemy.attack_distance:
		finished.emit(PURSUE, {'dir': direction, 'player': player})

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

func attack():
	if enemy.anim_sprite.frame in [5, 10, 11] and not enemy.hit_area.monitoring:
		enemy.hit_area.monitoring = true
	elif enemy.anim_sprite.frame not in [5, 10, 11] and enemy.hit_area.monitoring:
		enemy.hit_area.monitoring = false


func _on_hit_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player.stats.take_damage(enemy.stats.enemy_damage)
