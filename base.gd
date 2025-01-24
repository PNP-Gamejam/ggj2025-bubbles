extends Node2D

@export var hp := 10
@onready var _attackable: Attackable = $Attackable
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	_attackable.max_hp = hp
	_attackable.died.connect(func(): print("game_over"))
	_attackable.hp_changed.connect(func(): 
		print("attacked, hp now at: %d" % _attackable.hp)
		if _attackable.hp > 0:
			animated_sprite.frame = _attackable.max_hp / _attackable.hp
	)
