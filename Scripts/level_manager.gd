extends Node



var timer : Timer
@onready
var ui = $"%UI"

var score := 0

func _ready() -> void:
	timer = $LevelTimer
	timer.start()
	update_score(score)
	
	for plant in get_tree().get_nodes_in_group("plants"):
		plant.signal.connect(plant_status_updated)

func update_score(amount):
	score += amount
	ui.get_node("Score").text = "SCORE: %s" % str(int(score))

func _process(delta: float) -> void:
	ui.get_node("TimeLeft").text = str(int(timer.time_left))
	

func plant_status_updated(status):
	pass

func time_up():
	print("TIME UP!")
