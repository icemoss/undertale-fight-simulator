extends Sprite2D

@export var text_box : RichTextLabel
@export var item_1: Node2D
@export var item_2: Node2D
@export var item_3: Node2D
@export var item_4: Node2D

const messages = [
	"Surprisingly accurate simulation",
	"Faithfully sourced fonts",
	"Dodge the bullets!",
	"Remember to heal",
	"Have fun :D - IceMoss",
	"Doing well!",
	"Undertale but on the web",
	"Check out Deltarune!"
]

func _ready() -> void:
	# Display a random message
	text_box.text = messages[randi_range(0,messages.size()-1)]
	global.connect("mode_changed", on_mode_changed)
	global.connect("attack_ended", on_attack_ended)
	on_mode_changed()


func on_mode_changed() -> void:
	if global.mode == global.MODES.MENU:
		text_box.show()
		item_1.hide()
		item_2.hide()
		item_3.hide()
		item_4.hide()
		show()
	elif global.mode == global.MODES.ITEM_MENU:
		text_box.hide()
		item_1.show()
		item_2.show()
		item_3.show()
		item_4.show()
		show()
	else:
		hide()


func on_attack_ended() -> void:
	text_box.text = messages[randi_range(0,messages.size()-1)]
