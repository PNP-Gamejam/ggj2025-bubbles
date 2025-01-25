class_name Base
extends Node2D

signal died

@export var hp := 10
@onready var _attackable: Attackable = $Attackable
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	_attackable.max_hp = hp
	_attackable.died.connect(func():
		died.emit()
	)
	_attackable.hp_changed.connect(func(): 
		if _attackable.hp > 0:
			_shake()
			animated_sprite.frame = _attackable.max_hp / _attackable.hp
	)

func _shake():
	var origin = animated_sprite.position
	var tween = get_tree().create_tween()
	tween.tween_method(func(t): 
		animated_sprite.position = origin + \
			10 * pow(2, -.1*t) * sin(t)  * Vector2.RIGHT,
		0, 10 * PI, .5
	)
	tween.tween_callback(func(): animated_sprite.position = Vector2.ZERO)
	tween.play()
