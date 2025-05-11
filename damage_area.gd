class_name DamageArea
extends Area2D

@export var warm_up_duration := 500.0
@export var duration := 1.0
@export var warm_up_color := Color.GRAY
@export var normal_color := Color.WHITE
@export var damage := 8
var elapsed_time := 0.0
var warming_up := true

func _point_at_soul() -> void:
	look_at(global.soul_position)


func _physics_process(delta: float) -> void:
	elapsed_time += delta
	if warming_up and elapsed_time > warm_up_duration:
		elapsed_time -= warm_up_duration
		warming_up = false
	elif not warming_up and elapsed_time > duration:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("soul"):
		if global.mode != global.MODES.MENU:
			global.change_hp(-damage)
			queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
