extends Node2D

var elapsed_time := 0.0
var attack := 0
var cycles := 0

func _ready() -> void:
	global.connect("mode_changed", on_mode_changed)

func _process(delta: float) -> void:
	if global.mode == global.MODES.FIGHT:
		elapsed_time += delta
		match attack:
			0:
				if cycles < 5:
					if elapsed_time > 0.5:
						elapsed_time -= 0.1
						cycles += 1
						var bullet := load("res://bullet.tscn").instantiate() as Area2D
						bullet.global_position = Vector2(choose_randomly([0, 480]), randf_range(0,300))
						bullet._point_at_soul()
						add_child(bullet)
				elif cycles < 10:
					if elapsed_time > 0.3:
						elapsed_time -= 0.1
						cycles += 1
						var bullet := load("res://bullet.tscn").instantiate() as Area2D
						bullet.global_position = Vector2(randf_range(0, 480), 0)
						bullet._point_at_soul()
						add_child(bullet)
				else:
					if get_children().size() == 0:
						global.mode = global.MODES.MENU
						global.emit_signal("mode_changed")
			_:
				print("Attack %d" % [attack])
				global.mode = global.MODES.MENU
				global.emit_signal("mode_changed")


func choose_randomly(choices: Array):
	return choices[randi() % choices.size()]

func on_mode_changed() -> void:
	elapsed_time = 0
	if global.mode == global.MODES.MENU:
		attack += 1
