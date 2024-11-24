extends Resource
class_name PlantInfo

@export var health: int
@export var sprite: Texture2D
@export var decay: float
@export var alive: bool

func _init(p_health = 0, p_sprite = null, p_decay = 0, p_alive = true):
	health = p_health
	sprite = p_sprite
	decay = p_decay
	alive = p_alive
