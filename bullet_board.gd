extends StaticBody2D

func _ready() -> void:
	global.connect("mode_changed", on_mode_changed)
	on_mode_changed()


func on_mode_changed() -> void:
	if global.mode == global.MODES.FIGHT:
		show()
	else:
		hide()
