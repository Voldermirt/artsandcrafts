extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready
var sprite : AnimatedSprite2D = $AnimatedSprite2D

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
	
	if direction.x < 0:
		sprite.scale.x = abs(sprite.scale.x)
	if direction.x > 0:
		sprite.scale.x = -abs(sprite.scale.x)
	
	if direction.x == 0 and direction.y == 0:
		sprite.play("idle")
	else:
		sprite.play("walk")
		$Marker2D.rotation = ((2 * PI) + direction.angle())
	
	
	
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
