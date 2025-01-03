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
		if selected_plant and selected_plant.alive:
			water_plant(selected_plant)
			return
	if event.is_action_pressed("gnome_speech"):
		$WOO.play()

func water_plant(plant : Plant) -> void:
	if water >= 1:
		water -= 1
		water_updated.emit(water)
		plant.water()
		
		$WaterSound.play()
		$WaterSound/SoundStop.start()

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
		$Footsteps.stop()
	else:
		sprite.play("walk")
		if not $Footsteps.playing:
			$Footsteps.play()
		# Update interaction area
		$Marker2D.rotation = ((2 * PI) + direction.angle())
	
	select_plant()
	move_and_slide()

func select_plant():
	var prev_plant = selected_plant
	var plant = null
	var min_dist = 999999.0
	for body in $Marker2D/InteractArea.get_overlapping_bodies():
		if body is Plant and body.alive:
			# Select closest plant
			var dist = $Marker2D/InteractArea.global_position.distance_to(body.global_position)
			if dist < min_dist:
				min_dist = dist
				plant = body
	selected_plant = plant	
	if prev_plant != selected_plant:
		# Selected plant changed
		if selected_plant:
			selected_plant.get_node("WateringCan").visible = true
		if prev_plant:
			prev_plant.get_node("WateringCan").visible = false
	

#func interact_area_entered(body):
	#if body is Plant:
		#if selected_plant:
			#selected_plant.get_node("WateringCan").visible = false
		#selected_plant = body
		#selected_plant.get_node("WateringCan").visible = true
#
#func interact_area_exited(body):
	#if body is Plant and selected_plant:
		#selected_plant.get_node("WateringCan").visible = false
		## See if there's another plant that can be targeted instead
		#for b in $Marker2D/InteractArea.get_overlapping_bodies():
			#if b is Plant:
				#selected_plant = body
				#selected_plant.get_node("WateringCan").visible = true
				#return
		#selected_plant = null
