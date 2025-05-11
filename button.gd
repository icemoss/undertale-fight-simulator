extends Area2D

@export var unhighlighted_texture: Texture2D
@export var highlighted_texture: Texture2D
@export var item: global.ITEMS


@onready var sprite := $Sprite2D
@onready var text_label := $RichTextLabel

func _ready() -> void:
	sprite.texture = unhighlighted_texture
	global.connect("item_used", on_item_used)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("soul"):
		sprite.texture = highlighted_texture
		text_label.add_theme_color_override("default_color", Color.YELLOW)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("soul"):
		sprite.texture = unhighlighted_texture
		text_label.add_theme_color_override("default_color", Color.WHITE)


func on_item_used() -> void:
	if not global.inventory.has(item):
		text_label.hide()
