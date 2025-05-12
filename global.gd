extends Node

enum MODES { MENU, FIGHT, ITEM_MENU }

var mode := MODES.MENU

var hp := 99

var iframes := 0.0
var IFRAME_DURATION := 0.5

enum ITEMS { PIZZA, PIE, ICECREAM, BAGUETTE, NONE }

var inventory := [ITEMS.PIZZA, ITEMS.PIE, ITEMS.ICECREAM, ITEMS.BAGUETTE, ITEMS.NONE]

var broke: AudioStreamMP3
var hurt: AudioStreamMP3
var item: AudioStreamMP3
var menu: AudioStreamMP3
var player: AudioStreamPlayer
var broke_player: AudioStreamPlayer

enum SOUNDS { BROKE, MENU }


func _ready() -> void:
	broke = preload("res://sfx/break.mp3")
	hurt = preload("res://sfx/hurt.mp3")
	item = preload("res://sfx/item.mp3")
	menu = preload("res://sfx/menu.mp3")
	
	player = AudioStreamPlayer.new()	
	add_child(player)
	player.stream = preload("res://sfx/battlestart.mp3")
	player.play()
	broke_player = AudioStreamPlayer.new()
	broke_player.stream = broke
	add_child(broke_player)

func change_hp(amount: int) -> void:
	if iframes == 0.0 or amount > 0:
		hp += amount
		if hp < 0:
			hp = 0
		elif hp > 99:
			hp = 99
		emit_signal("hp_changed")
		if amount < 0:
			iframes = IFRAME_DURATION
			player.stream = hurt
			player.play()
		else:
			player.stream = item
			player.play()

func play_sound(sound: SOUNDS) -> void:
	print(sound)
	match sound:
		SOUNDS.BROKE:
			broke_player.play()
		SOUNDS.MENU:
			player.stream = menu
			player.play()
		_:
			player.stream = preload("res://sfx/battlestart.mp3")
			player.play()


var soul_position = Vector2()

@warning_ignore("unused_signal")
signal mode_changed

@warning_ignore("unused_signal")
signal hp_changed

@warning_ignore("unused_signal")
signal attack_ended

@warning_ignore("unused_signal")
signal item_used
