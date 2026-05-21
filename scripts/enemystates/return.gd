extends EnemyState

@onready var player_lost_timer: Timer = $"../../PlayerLostTimer"
var spotted_player: bool
var distance: float
var direction: int
var player: Player

func enter(previous_state_path: String, data := {}) -> void:
	enemy.anim_sprite.play('Run')
	spotted_player = false
	enemy.stats.health_change.connect(_on_getting_damaged)
	direction = -1 if enemy.position.x > enemy.patrol_center_x else 1
	flipping()

func physics_update(_delta: float) -> void:
	distance = enemy.position.x - enemy.patrol_center_x
	direction = -1 if distance > 0 else 1
	enemy.velocity.y += enemy.gravity * _delta
	enemy.velocity.x = enemy.pursue_speed * _delta * direction
	enemy.move_and_slide()
	
	flipping()
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
	if spotted_player:
		player = target

func state_change():
	if spotted_player:
		print('Spotted the player')
		finished.emit(PURSUE, {'dir': direction, 'player': player})
	elif round(distance) == 0:
		finished.emit(PATROL)

func handle_animations():
	pass

func flipping():
	if not enemy.is_flipped and direction < 0:
		enemy.pivot.apply_scale(Vector2(-1, 1))
		enemy.is_flipped = true
		enemy.anim_sprite.flip_h = enemy.is_flipped
	elif enemy.is_flipped and direction > 0:
		enemy.pivot.apply_scale(Vector2(-1, 1))
		enemy.is_flipped = false
		enemy.anim_sprite.flip_h = enemy.is_flipped

func _on_getting_damaged() -> void:
	direction = -direction
