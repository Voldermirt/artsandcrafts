extends Node



var timer : Timer
@onready
var ui = $"%UI"

var score := 0

func _ready() -> void:
	timer = $LevelTimer
	timer.start()
	update_score(score)

func update_score(amount):
	score += amount
	ui.get_node("Score").text = "SCORE: %s" % str(int(score))

func _process(delta: float) -> void:
	ui.get_node("TimeLeft").text = str(int(timer.time_left))
	

func time_up():
	print("TIME UP!")
