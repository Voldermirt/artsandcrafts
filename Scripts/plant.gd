extends StaticBody2D
class_name Plant

signal on_plant_death(negate_score)
signal on_plant_watered(add_score)
@export var stats: Resource
@export var gradient: Gradient

# default values that will be changed by plant resource
var max_health = 100
var health = 100
var alive = true
var score = 10

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
    
    # Y Sort
    if global_position.y > get_tree().get_first_node_in_group("player").global_position.y:
        $Plant.z_index = 2
    else:
        $Plant.z_index = 0

func water():
    health = max_health
    $ProgressBar.value = health
    on_plant_watered.emit(score)

func die():
    alive = false
    $Plant.modulate = Color.SADDLE_BROWN
    $Panel.visible = false
    $ProgressBar.visible = false

func tick():
    # Decay represents how likely the plant is to take damage
    # This is definitely more complicated then it needs to be
    # But I already coded it all, so
    if randf() < stats.decay:
        # Take damage
        health = clamp(health - 1, 0, max_health)
        $ProgressBar.value = health
        if health <= 0:
            die()
            on_plant_death.emit(-10)
            print("signal sent, 10 score negated")

func set_stats(s):
    stats = s
    $Plant.texture = s.sprite
    max_health = s.health
    health = max_health
    alive = stats.alive
    score = stats.score
    $ProgressBar.max_value = max_health
    $ProgressBar.value = health
    

func add_health(amount):
    health = clamp(health + amount, 0, max_health)
