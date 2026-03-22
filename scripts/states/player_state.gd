class_name PlayerState extends State

const IDLE = "Idle"
const CROUCHING = "Crouching"
const WALKING = "Walking"
const RUNNING = "Running"
const CROUCHWALKING = "CrouchWalking"
const JUMPING = "Jumping"
const FALLING = "Falling"
const ATTACK = "Attacking"


var player: Player


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
