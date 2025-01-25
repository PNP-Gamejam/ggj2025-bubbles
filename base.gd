extends Node2D

@export var hp := 10
@onready var _attackable: Attackable = $Attackable
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	_attackable.max_hp = hp
	_attackable.died.connect(func(): print("game_over"))
	_attackable.hp_changed.connect(func(): 
		if _attackable.hp > 0:
			_shake()
			animated_sprite.frame = _attackable.max_hp / _attackable.hp
	)

func _shake():
	var origin = global_position
	var tween = get_tree().create_tween()
	tween.tween_method(func(t): 
		global_position = origin + \
			10 * pow(2, -.1*t) * sin(t)  * Vector2.RIGHT,
		0, 10*PI, .5
	)
	tween.tween_callback(func(): global_position = origin)
	tween.play()
