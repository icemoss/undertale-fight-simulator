extends Node

enum MODES { MENU, FIGHT, ITEM_MENU }

var mode := MODES.MENU

var hp := 99

var iframes := 0.0
var IFRAME_DURATION := 0.5

enum ITEMS { PIZZA, PIE, ICECREAM, BAGUETTE, NONE }

var inventory := [ITEMS.PIZZA, ITEMS.PIE, ITEMS.ICECREAM, ITEMS.BAGUETTE, ITEMS.NONE]

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

var soul_position = Vector2()

@warning_ignore("unused_signal")
signal mode_changed

@warning_ignore("unused_signal")
signal hp_changed

@warning_ignore("unused_signal")
signal attack_ended

@warning_ignore("unused_signal")
signal item_used
