class_name Attackable
extends Area2D

@export var max_hp := 10
@onready var _hp = max_hp

var hp: set = _set_hp, get = _get_hp

signal hp_changed
signal died

func _set_hp(v: float):
	_hp = clamp(v, 0, max_hp)
	hp_changed.emit()
	if _hp <= 0:
		died.emit()

func _get_hp():
	return _hp
