extends Node



var timer : Timer
@onready
var ui = $"%UI"

@export var plants : Array[PlantInfo]

var score := 0

func _ready() -> void:
	randomize()
	timer = $LevelTimer
	timer.start()
	update_score(score)
	
	for plant in $plants.get_children():
		plant.on_plant_death.connect(plant_died)
		plant.on_plant_watered.connect(plant_watered)
		# Randomize plant
		plant.set_stats(plants.pick_random())
	
	get_tree().get_first_node_in_group("player").water_updated.connect(update_water_ui)
	

func update_water_ui(water_level):
	ui.get_node("drop1").visible = water_level >= 1
	ui.get_node("drop2").visible = water_level >= 2
	ui.get_node("drop3").visible = water_level >= 3

func update_score(amount):
	score += amount
	ui.get_node("Score").text = "SCORE: %s" % str(int(score))

func _process(delta: float) -> void:
	ui.get_node("TimeLeft").text = str(int(timer.time_left))



func plant_died(score):
	update_score(score)

func plant_watered(score):
	update_score(score)

func time_up():
	print("TIME UP!")

# when the hose finishes its progress bar, add water points
func _on_hose_on_hose_water_filled(amount: Variant) -> void:
	get_tree().get_first_node_in_group("player").fill_water(amount)
