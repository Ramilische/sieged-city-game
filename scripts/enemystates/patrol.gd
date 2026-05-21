extends EnemyState

@onready var wait_timer: Timer = $"../../WaitTimer"

var spotted_player: bool
var player: Player
var walking: bool
var target_point: float
var epsilon: float = 10.0
var direction: int
var pivot: Node2D
var rays: Node2D


func enter(previous_state_path: String, data := {}) -> void:
	enemy.velocity.x = 0.0
	enemy.anim_sprite.play("Idle")
	spotted_player = false
	walking = false
	pivot = enemy.find_child('Pivot')
	rays = pivot.find_child('Rays')
	enemy.stats.health_change.connect(_on_getting_damaged)
	direction = [-1, 1][randi_range(0, 1)]
	flipping()

func physics_update(_delta: float) -> void:
	enemy.velocity.y += enemy.gravity * _delta
	patrol_walk(_delta)
	enemy.move_and_slide()
	flipping()
	handle_animations()
	look_for_player()
	state_change()


func patrol_walk(delta: float):
	if not walking and wait_timer.is_stopped():
		wait_timer.start(enemy.patrol_stand_time)
		enemy.velocity.x = 0
	elif not walking and enemy.velocity.x != 0:
		enemy.velocity.x = 0
	elif walking:
		enemy.velocity.x = enemy.patrol_speed * delta * direction
		if target_point - epsilon < enemy.position.x and enemy.position.x < target_point + epsilon:
			walking = false

func set_target_point():
	target_point = enemy.patrol_center_x + direction * enemy.patrol_x_reach

func look_for_player():
	var target: Player
	for ray: RayCast2D in rays.get_children():
		if ray.is_colliding() and ray.get_collider() is Player:
			target = ray.get_collider()
			player = target
			break
	spotted_player = target != null

func state_change():
	if spotted_player:
		print('Player spotted!!!')
		finished.emit(PURSUE, {'dir': direction, 'player': player})

func handle_animations():
	if walking and enemy.anim_sprite.animation == "Idle":
		enemy.anim_sprite.play("Run")
	elif not walking and enemy.anim_sprite.animation == "Run":
		enemy.anim_sprite.play("Idle")

func flipping():
	if not enemy.is_flipped and direction < 0:
		pivot.apply_scale(Vector2(-1, 1))
		enemy.is_flipped = true
		enemy.anim_sprite.flip_h = enemy.is_flipped
	elif enemy.is_flipped and direction > 0:
		pivot.apply_scale(Vector2(-1, 1))
		enemy.is_flipped = false
		enemy.anim_sprite.flip_h = enemy.is_flipped


func _on_wait_timer_timeout() -> void:
	walking = true
	direction = -direction
	enemy.anim_sprite.flip_h = false if direction == 1 else true
	set_target_point()
	wait_timer.stop()

func _on_getting_damaged() -> void:
	direction = -direction
