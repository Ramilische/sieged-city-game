class_name EnemyState extends State

const PATROL = "Patrol"
const PURSUE = "Pursue"
const ATTACK = "Attack"
const RETURN = "Return"


var enemy: Enemy


func _ready() -> void:
	await owner.ready
	enemy = owner as Enemy
	assert(enemy != null, "The EnemyState state type must be used only in the enemy scene. It needs the owner to be a Enemy node.")
