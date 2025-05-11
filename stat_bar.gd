extends Control

@export var hp_bar : ProgressBar
@export var hp_label : RichTextLabel


func _ready() -> void:
	global.connect("hp_changed", on_hp_changed)


func on_hp_changed() -> void:
	hp_bar.value = global.hp
	hp_label.text = str(global.hp) + " / 99"
