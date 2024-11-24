extends Node



var timer : Timer
@onready
var ui = $"%UI"

@export var plants : Array[PlantInfo]

@onready var start = $UI/HowToPlay/CenterContainer/PanelContainer/VBoxContainer/Start
@onready var how_to_play = $UI/HowToPlay

@onready var end_screen = $UI/EndScreen
@onready var end_plants_alive = $UI/EndScreen/CenterContainer/PanelContainer/PerformanceContainer/ScoreLabel
@onready var end_plants_dead = $UI/EndScreen/CenterContainer/PanelContainer/PerformanceContainer/DeadLabel
@onready var end_total_score = $UI/EndScreen/CenterContainer/PanelContainer/PerformanceContainer/TotalLabel
@onready var end_message = $UI/EndScreen/CenterContainer/PanelContainer/PerformanceContainer/JudgementLabel

var score := 0

# determines if the how to play screen should be shown when restarting
var first_playthrough = true

# holds number of plants alive or dead
var plants_alive: int = 0
var plants_dead: int = 0

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
	
	if first_playthrough:
		how_to_play.show()
		# immediately highlight the button
		start.grab_focus()
		# pause the tree so the player can read the instructions
		get_tree().paused = true

func update_water_ui(water_level):
	ui.get_node("drop1").visible = water_level >= 1
	ui.get_node("drop2").visible = water_level >= 2
	ui.get_node("drop3").visible = water_level >= 3

func update_score(amount):
	score += amount
	ui.get_node("Score").text = "SCORE: %s" % str(int(score))

func _process(delta: float) -> void:
	ui.get_node("TimeLeft").text = str(ceil(timer.time_left))



func plant_died(score):
	update_score(score)

func plant_watered(score):
	update_score(score)
	print("plant watered", " score + ", score)

# Time runs out
func time_up():
	get_tree().paused = true
	
	# calculate dead and alive plants
	for plant in $plants.get_children():
		if plant.alive:
			plants_alive += 1
		else:
			plants_dead += 1
	
	# add or subtract score
	score += 5 * plants_alive
	score -= 10 * plants_dead
	
	# dynamically change the end screen text
	end_plants_alive.text = "No. Of Plants Alive: " + str(plants_alive) + " | +" + str(5 * plants_alive)
	end_plants_dead.text = "No. Of Plants Dead: " + str(plants_dead) + " | -" + str(10 * plants_dead)
	end_total_score.text = "TOTAL SCORE: " + str(score)
	if score < 0:
		end_message.text = "You defintely don't have a green thumb..."
	elif score == 0:
		end_message.text = "Equally balanced as all things should be???"
	elif score > 0:
		end_message.text = "Nice job!" 
	
	$UI/EndScreen.show()

# when the hose finishes its progress bar, add water points
func _on_hose_on_hose_water_filled(amount: Variant) -> void:
	$Gnome.fill_water(amount)


func _on_start_pressed() -> void:
	how_to_play.hide()
	first_playthrough = false
	get_tree().paused = false


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().quit()
