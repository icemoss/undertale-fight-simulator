extends Area2D


@export var speed := 200.0

func _point_at_soul() -> void:
	look_at(global.soul_position)


func _physics_process(delta: float) -> void:
	var velocity := Vector2(1,0).rotated(rotation) * speed * delta
	
	global_position += velocity


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("soul"):
		global.mode = global.MODES.MENU
		global.emit_signal("mode_changed")
		for child in get_parent().get_children():
			child.queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
