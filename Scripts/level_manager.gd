extends Node



var timer : Timer
@onready
var ui = $"%UI"

var score := 0

func _ready() -> void:
	timer = $LevelTimer
	timer.start()
	update_score(score)
	
	for plant in $plants.get_children():
		plant.on_plant_death.connect(plant_died)

func update_score(amount):
	score += amount
	ui.get_node("Score").text = "SCORE: %s" % str(int(score))

func _process(delta: float) -> void:
	ui.get_node("TimeLeft").text = str(int(timer.time_left))
	

func plant_died(score):
	update_score(score)

func time_up():
	print("TIME UP!")
