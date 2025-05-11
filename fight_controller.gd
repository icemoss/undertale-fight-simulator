extends Node2D

var elapsed_time := 0.0
var attack := 0
var cycles := 0

func _ready() -> void:
	global.connect("mode_changed", on_mode_changed)
	global.connect("hp_changed", on_hp_changed)
	global.connect("attack_ended", on_attack_ended)


func _process(delta: float) -> void:
	if global.mode == global.MODES.FIGHT:
		elapsed_time += delta
		match attack:
			0:
				if cycles < 10:
					if elapsed_time > 0.3:
						elapsed_time -= 0.3
						cycles += 1
						var spawn_height := randi_range(0, 300)
						spawn_bullet(0, spawn_height)
						spawn_bullet(640, spawn_height)
				else:
					detect_finished_attack()
			1:
				if cycles < 20:
					if elapsed_time > 0.5:
						elapsed_time -= 0.5
						cycles += 1
						for i in range(5):
							spawn_bullet(0 if cycles % 2 == 0 else 640, randi_range(0, 300))
				else:
					detect_finished_attack()
			_:
				global.mode = global.MODES.MENU
				global.emit_signal("mode_changed")


func spawn_bullet(x: int, y: int):
	var bullet := load("res://bullet.tscn").instantiate() as Bullet
	bullet.global_position = Vector2(x, y)
	bullet.speed = 150
	bullet._point_at_soul()
	add_child(bullet)


func choose_randomly(choices: Array):
	return choices[randi() % choices.size()]


func detect_finished_attack() -> void:
	if get_children().size() == 0:
		global.emit_signal("attack_ended")
		global.mode = global.MODES.MENU
		global.emit_signal("mode_changed")


func on_mode_changed() -> void:
	pass


func on_hp_changed() -> void:
	if global.hp <= 0:
		for child in get_children():
			child.queue_free()
		global.hp = 0
		global.mode = global.MODES.MENU
		global.emit_signal("mode_changed")


func on_attack_ended() -> void:
	elapsed_time = 0
	cycles = 0
	attack += 1
	if attack > 1:
		attack = 0
