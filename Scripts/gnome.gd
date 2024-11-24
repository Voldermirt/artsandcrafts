extends CharacterBody2D

signal water_updated(level)

@export  var speed = 300.0
@export var accel = 40.0

var max_water = 3
var water = 3

var selected_plant : Plant = null

@onready
var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if selected_plant:
			water_plant(selected_plant)
			return
	if event.is_action_pressed("gnome_speech"):
		$WOO.play()

func water_plant(plant : Plant) -> void:
	if water >= 1:
		water -= 1
		water_updated.emit(water)
		plant.water()

# add amount to water level
func fill_water(amount):
	water = clamp(water + amount, 0, 3)
	water_updated.emit(water)

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

	move_and_slide()

func interact_area_entered(body):
	if body is Plant:
		if selected_plant:
			selected_plant.get_node("WateringCan").visible = false
		selected_plant = body
		selected_plant.get_node("WateringCan").visible = true

func interact_area_exited(body):
	if body is Plant and selected_plant:
		selected_plant.get_node("WateringCan").visible = false
		selected_plant = null
