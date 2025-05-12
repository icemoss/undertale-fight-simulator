class_name DamageArea
extends Area2D

@export var warm_up_duration := 0.5
@export var duration := 1.0
@export var warm_up_color := Color.DARK_GRAY
@export var normal_color := Color.WHITE
@export var damage := 6
var elapsed_time := 0.0
var warming_up := true
@onready var polygon := $Polygon2D


func _ready() -> void:
	polygon.color = warm_up_color


func _physics_process(delta: float) -> void:
	elapsed_time += delta
	if warming_up and elapsed_time > warm_up_duration:
		elapsed_time -= warm_up_duration
		polygon.color = normal_color
		warming_up = false
	elif not warming_up and elapsed_time > duration:
		queue_free()
	
	for body in get_overlapping_bodies():
		if body.is_in_group("soul") and global.mode != global.MODES.MENU and not warming_up:
			global.change_hp(-damage)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
