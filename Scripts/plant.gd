extends StaticBody2D
class_name Plant

signal on_plant_death(negate_score)
@export var stats: Resource
@export var gradient: Gradient

var max_health = 100
var health = 100
var alive = true

@export var tps := 2
var tick_timer = 0.0

# Replaces sprite with sprite in the resources
func _ready() -> void:
	if stats:
		set_stats(stats)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alive:
		tick_timer += delta
		if tick_timer >= (1.0 / tps):
			tick()
			tick_timer = 0.0
			
	$ProgressBar.self_modulate = gradient.sample(float(health) / max_health)

func water():
	health = max_health
	$ProgressBar.value = health

func tick():
	# Decay represents how likely the plant is to take damage
	# This is definitely more complicated then it needs to be
	# But I already coded it all, so
	if randf() < stats.decay:
		# Take damage
		health = clamp(health - 1, 0, max_health)
		$ProgressBar.value = health
		if health <= 0:
			alive = false
			emit_signal("on_plant_death", -10)
			print("signal sent, 10 score negated")

func set_stats(s):
	stats = s
	$Plant.texture = s.sprite
	max_health = s.health
	health = max_health
	alive = stats.alive
	$ProgressBar.max_value = max_health
	$ProgressBar.value = health
	

func add_health(amount):
	health = clamp(health + amount, 0, max_health)
