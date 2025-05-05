extends Node

enum MODES { MENU, FIGHT }

var mode := MODES.MENU

var soul_position = Vector2()

signal mode_changed
