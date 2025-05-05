extends CharacterBody2D

## Speed in pixels per second.
@export_range(0, 1000) var speed := 60

enum LOCATIONS { FIGHT, ACT, ITEM, MERCY, BOARD }


var location := LOCATIONS.FIGHT
var last_button := LOCATIONS.FIGHT

func _ready() -> void:
	global.connect("mode_changed", on_mode_changed)


func on_mode_changed():
	if global.mode == global.MODES.MENU:
		print(last_button)
		move_to_location(last_button)

func _physics_process(_delta: float) -> void:
	if global.mode == global.MODES.FIGHT:
		update_velocity()
		move_and_slide()
	global.soul_position = Vector2(global_position.x, global_position.y)


func update_velocity() -> void:
	var vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = vector * speed


func _process(_delta: float) -> void:
	if global.mode == global.MODES.MENU:
		if Input.is_action_just_pressed("ui_right"):
			match location:
				LOCATIONS.FIGHT:
					move_to_location(LOCATIONS.ACT)
				LOCATIONS.ACT:
					move_to_location(LOCATIONS.ITEM)
				LOCATIONS.ITEM:
					move_to_location(LOCATIONS.MERCY)
		if Input.is_action_just_pressed("ui_left"):
			match location:
				LOCATIONS.ACT:
					move_to_location(LOCATIONS.FIGHT)
				LOCATIONS.ITEM:
					move_to_location(LOCATIONS.ACT)
				LOCATIONS.MERCY:
					move_to_location(LOCATIONS.ITEM)
		if Input.is_action_just_pressed("ui_accept"):
			if global.mode == global.MODES.MENU:
				global.mode = global.MODES.FIGHT
				#global.emit_signal("mode_changed")
				last_button = location
				move_to_location(LOCATIONS.BOARD)


func move_to_location(new_location: LOCATIONS) -> void:
	location = new_location
	match new_location:
		LOCATIONS.FIGHT:
			global_position.x = 47
			global_position.y = 453
		LOCATIONS.ACT:
			global_position.x = 200
			global_position.y = 453
		LOCATIONS.ITEM:
			global_position.x = 360
			global_position.y = 453
		LOCATIONS.MERCY:
			global_position.x = 515
			global_position.y = 453
		LOCATIONS.BOARD:
			global_position.x = 320
			global_position.y = 319
