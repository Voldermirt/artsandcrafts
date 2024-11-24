extends StaticBody2D

signal on_hose_water_filled(amount)

@onready var progress_bar = $ProgressBar
@onready var timer = $HoseTimer
@onready var progress_bar_panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_bar.value = timer.wait_time - timer.time_left
	if global_position.y > get_tree().get_first_node_in_group("player").global_position.y:
		$Sprite2D.z_index = 2
		$GPUParticles2D.z_index = 2
	else:
		$Sprite2D.z_index = 0
		$GPUParticles2D.z_index = 0


func _on_collection_area_body_entered(body: Node2D) -> void:
	if body.name == "Gnome":
		timer.start()
		progress_bar.show()
		progress_bar_panel.show()


func _on_collection_area_body_exited(body: Node2D) -> void:
	progress_bar.hide()
	progress_bar_panel.hide()
	timer.stop()


func _on_hose_timer_timeout() -> void:
	# replenish 1 water point
	on_hose_water_filled.emit(1)
