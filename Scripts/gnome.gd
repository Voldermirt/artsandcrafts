extends CharacterBody2D

signal water_updated(level)

@export  var speed = 300.0
@export var accel = 40.0

var max_water = 3
var water = 3

@onready
var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		for body in $Marker2D/InteractArea.get_overlapping_bodies():
			if body is Plant:
				water_plant(body)
				return

func water_plant(plant : Plant) -> void:
	if water >= 1:
		water -= 1
		water_updated.emit(water)
		plant.water()

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	# Move
	var target_vel = Vector2.ZERO
	if direction:
		target_vel = direction.normalized() * speed
	velocity.x = move_toward(velocity.x, target_vel.x, accel)
	velocity.y = move_toward(velocity.y, target_vel.y, accel)
	
	# Flip Sprite
	if direction.x < 0:
		sprite.scale.x = abs(sprite.scale.x)
	if direction.x > 0:
		sprite.scale.x = -abs(sprite.scale.x)
	
	# Animations
	if direction.x == 0 and direction.y == 0:
		sprite.play("idle")
	else:
		sprite.play("walk")
		# Update interaction area
		$Marker2D.rotation = ((2 * PI) + direction.angle())
	
	
	
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
