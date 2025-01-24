extends Node2D

@export var hp := 10
@onready var _attackable: Attackable = $Attackable

func _ready() -> void:
	_attackable.max_hp = hp
	_attackable.died.connect(func(): print("game_over"))
	_attackable.hp_changed.connect(func(): print("attacked, hp now at: %d" % _attackable.hp))
