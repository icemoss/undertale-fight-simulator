class_name Bullet
extends Area2D

@export var speed := 200.0
@export var damage := 8

func _point_at_soul() -> void:
	look_at(global.soul_position)


func _physics_process(delta: float) -> void:
	var velocity := Vector2(1,0).rotated(rotation) * speed * delta
	global_position += velocity
	
	for body in get_overlapping_bodies():
		if body.is_in_group("soul") and global.mode != global.MODES.MENU:
			global.change_hp(-damage)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
