extends Node2D

var elapsed_time := 0.0
var attack := 0
var cycles := 0

# 240 - 400 x
# 250 - 400 y

func _ready() -> void:
	global.connect("hp_changed", on_hp_changed)
	global.connect("attack_ended", on_attack_ended)
	#debug
	attack = 6


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
						spawn_bullet(0, spawn_height, 120.0)
						spawn_bullet(640, spawn_height, 120.0)
						spawn_damage_area(randi_range(240, 350), randi_range(250,350), 30, 30, 0.5, 1.0)
				else:
					detect_finished_attack()
			1:
				if cycles < 5:
					if elapsed_time > 0.5:
						elapsed_time -= 0.5
						cycles += 1
						for i in range(5):
							spawn_bullet(0 if cycles % 2 == 0 else 640, randi_range(0, 300), 130.0)
				else:
					detect_finished_attack()
			2:
				if cycles < 5:
					if elapsed_time > 0.2:
						elapsed_time -= 0.2
						cycles += 1
						spawn_damage_area(randi_range(240, 350), randi_range(250,350), 50, 50, 1.0, 3.0)
				else:
					detect_finished_attack()
			3:
				if cycles < 20:
					if elapsed_time > 0.1:
						elapsed_time -= 0.1
						cycles += 1
						spawn_bullet(0 if cycles % 2 == 0 else 640, randi_range(0, 300), 150.0)
				else:
					detect_finished_attack()
			4:
				if cycles < 4:
					if elapsed_time > 1.4:
						elapsed_time -= 1.4
						cycles += 1
						if cycles % 2 == 0:
							spawn_damage_area(243, 254, 78, 130, 2.1, 0.7)
						else:
							spawn_damage_area(321, 254, 77, 130, 2.1, 0.7)
				else:
					detect_finished_attack()
			5:
				if cycles < 20:
					if elapsed_time > 0.3:
						elapsed_time -= 0.3
						cycles += 1
						spawn_bullet(0 if randi_range(0,1) == 0 else 640, randi_range(0, 300), 200.0)
				else:
					detect_finished_attack()
			6:
				if cycles < 50:
					if elapsed_time > 0.4:
						elapsed_time -= 0.4
						cycles += 1
						spawn_bullet(randi_range(243, 398), 0, 400.0)
				else:
					detect_finished_attack()
			_:
				global.mode = global.MODES.MENU
				global.emit_signal("mode_changed")


func spawn_bullet(x: int, y: int, speed: float) -> void:
	var bullet := load("res://bullet.tscn").instantiate() as Bullet
	bullet.global_position = Vector2(x, y)
	bullet.speed = speed
	bullet._point_at_soul()
	add_child(bullet)


func spawn_damage_area(x: int, y: int, width: int, height: int, warm_up_duration: float, duration: float) -> void:
	var damage_area := load("res://damage_area.tscn").instantiate() as DamageArea
	damage_area.global_position = Vector2(x, y)
	damage_area.scale = Vector2(width, height)
	damage_area.warm_up_duration = warm_up_duration
	damage_area.duration = duration
	add_child(damage_area)


func choose_randomly(choices: Array):
	return choices[randi() % choices.size()]


func detect_finished_attack() -> void:
	if get_children().size() == 0:
		global.emit_signal("attack_ended")
		global.mode = global.MODES.MENU
		global.emit_signal("mode_changed")


func on_hp_changed() -> void:
	if global.hp <= 0:
		for child in get_children():
			child.queue_free()
		global.hp = 0
		
		global.mode = global.MODES.MENU
		global.emit_signal("mode_changed")
		global.play_sound(global.SOUNDS.BROKE)



func on_attack_ended() -> void:
	elapsed_time = 0
	cycles = 0
	attack += 1
	if attack > 6:
		attack = 0
