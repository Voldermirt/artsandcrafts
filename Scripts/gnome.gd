extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if direction:
		velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
