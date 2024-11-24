extends StaticBody2D

signal on_plant_death(negate_score)
@export var stats: Resource
@export var gradient: Gradient

var max_health = 100
var health = 100
var alive = true

# Replaces sprite with sprite in the resources
func _ready() -> void:
	if stats:
		max_health = stats.health
		health = max_health
		$Sprite2D.texture = stats.sprite
		alive = stats.alive

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alive:
		health = clamp(health - stats.decay, 0, 100)
		$ProgressBar.value = health
		if health <= 0:
			alive = false
			emit_signal("on_plant_death", -10)
			print("signal sent, 10 score negated")
	$ProgressBar.get_theme_stylebox("fill").bg_color = gradient.sample(health / max_health)

func add_health(amount):
	health = clamp(health + amount, 0, 100)
