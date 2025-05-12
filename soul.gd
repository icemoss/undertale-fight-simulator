extends CharacterBody2D

## Speed in pixels per second.
@export_range(0, 1000) var speed := 60

@export var texture : Texture2D
@export var iframe_texture : Texture2D

@onready var sprite := $Sprite2D

enum LOCATIONS { FIGHT, ACT, ITEM, MERCY, BOARD, ITEM_1, ITEM_2, ITEM_3, ITEM_4 }


var location := LOCATIONS.FIGHT
var last_button := LOCATIONS.FIGHT

func _ready() -> void:
	global.connect("mode_changed", on_mode_changed)


func on_mode_changed():
	if global.mode == global.MODES.MENU:
		move_to_location(last_button)


func _physics_process(delta: float) -> void:
	if global.mode == global.MODES.FIGHT:
		update_velocity()
		move_and_slide()
	global.soul_position = Vector2(global_position.x, global_position.y)
	global.iframes -= delta
	if global.iframes < 0.0:
		global.iframes = 0.0


func update_velocity() -> void:
	var vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_action_pressed("ui_cancel"):
		velocity = vector * speed / 2
	else:
		velocity = vector * speed


func _process(_delta: float) -> void:
	if global.iframes == 0:
		sprite.texture = texture
	else:
		sprite.texture = iframe_texture
	if global.mode == global.MODES.MENU:
		if Input.is_action_just_pressed("ui_left"):
			match location:
				LOCATIONS.ACT:
					move_to_location(LOCATIONS.FIGHT)
				LOCATIONS.ITEM:
					move_to_location(LOCATIONS.ACT)
				LOCATIONS.MERCY:
					move_to_location(LOCATIONS.ITEM)
		if Input.is_action_just_pressed("ui_right"):
			match location:
				LOCATIONS.FIGHT:
					move_to_location(LOCATIONS.ACT)
				LOCATIONS.ACT:
					move_to_location(LOCATIONS.ITEM)
				LOCATIONS.ITEM:
					move_to_location(LOCATIONS.MERCY)
		if Input.is_action_just_pressed("ui_accept"):
			if global.mode == global.MODES.MENU:
				if location == LOCATIONS.MERCY:
					get_tree().quit()
				elif global.hp > 0:
					if location == LOCATIONS.ITEM:
						global.mode = global.MODES.ITEM_MENU
						move_to_location(LOCATIONS.ITEM_1)
						global.emit_signal("mode_changed")
					else:
						global.mode = global.MODES.FIGHT
						global.emit_signal("mode_changed")
						last_button = location
						move_to_location(LOCATIONS.BOARD)
	
	elif global.mode == global.MODES.ITEM_MENU:
		if Input.is_action_just_pressed("ui_left"):
			match location:
				LOCATIONS.ITEM_2:
					move_to_location(LOCATIONS.ITEM_1)
				LOCATIONS.ITEM_4:
					move_to_location(LOCATIONS.ITEM_3)
		if Input.is_action_just_pressed("ui_right"):
			match location:
				LOCATIONS.ITEM_1:
					move_to_location(LOCATIONS.ITEM_2)
				LOCATIONS.ITEM_3:
					move_to_location(LOCATIONS.ITEM_4)
		if Input.is_action_just_pressed("ui_down"):
			match location:
				LOCATIONS.ITEM_1:
					move_to_location(LOCATIONS.ITEM_3)
				LOCATIONS.ITEM_2:
					move_to_location(LOCATIONS.ITEM_4)
		if Input.is_action_just_pressed("ui_up"):
			match location:
				LOCATIONS.ITEM_3:
					move_to_location(LOCATIONS.ITEM_1)
				LOCATIONS.ITEM_4:
					move_to_location(LOCATIONS.ITEM_2)
		if Input.is_action_just_pressed("ui_accept"):
			match location:
				LOCATIONS.ITEM_1:
					use_item(global.ITEMS.PIZZA)
				LOCATIONS.ITEM_2:
					use_item(global.ITEMS.PIE)
				LOCATIONS.ITEM_3:
					use_item(global.ITEMS.ICECREAM)
				LOCATIONS.ITEM_4:
					use_item(global.ITEMS.BAGUETTE)
		if Input.is_action_just_pressed("ui_cancel"):
			global.mode = global.MODES.MENU
			global.emit_signal("mode_changed")
			move_to_location(LOCATIONS.ITEM)


func use_item(item: global.ITEMS):
	if global.inventory.has(item):
		global.inventory.erase(item)
		match item:
			global.ITEMS.PIZZA:
				global.change_hp(20)
			global.ITEMS.PIE:
				global.change_hp(30)
			global.ITEMS.ICECREAM:
				global.change_hp(50)
			global.ITEMS.BAGUETTE:
				global.change_hp(90)
		global.emit_signal("item_used")
		global.mode = global.MODES.FIGHT
		global.emit_signal("mode_changed")
		last_button = LOCATIONS.ITEM
		move_to_location(LOCATIONS.BOARD)


func move_to_location(new_location: LOCATIONS) -> void:
	location = new_location
	global.play_sound(global.SOUNDS.MENU)
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
		LOCATIONS.ITEM_1:
			global_position.x = 70
			global_position.y = 281
		LOCATIONS.ITEM_2:
			global_position.x = 299
			global_position.y = 281
		LOCATIONS.ITEM_3:
			global_position.x = 70
			global_position.y = 336
		LOCATIONS.ITEM_4:
			global_position.x = 299
			global_position.y = 336
