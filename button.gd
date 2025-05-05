extends Area2D

@export var unhighlighted_button: Texture2D
@export var highlighted_button: Texture2D

@onready var button_sprite := $Sprite2D

func _ready() -> void:
	button_sprite.texture = unhighlighted_button


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("soul"):
		button_sprite.texture = highlighted_button


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("soul"):
		button_sprite.texture = unhighlighted_button
