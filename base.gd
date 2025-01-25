class_name Base
extends Node2D

signal died

@export var hp := 10
@onready var _attackable: Attackable = $Attackable
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var attacked_particles: GPUParticles2D = $AttackedParticles2D

func _ready() -> void:
	_attackable.max_hp = hp
	_attackable.hp = hp
	_attackable.died.connect(func():
		died.emit()
	)
	_attackable.hp_changed.connect(func(): 
		if _attackable.hp > 0:
			_shake()
			var new_frame = int(_attackable.max_hp / _attackable.hp)
			print(_attackable.max_hp, " ", _attackable.hp, " ", new_frame, " ", animated_sprite.frame)
			if new_frame != animated_sprite.frame:
				attacked_particles.restart()
				GlobalBus.health_threshold_reached.emit()
				animated_sprite.frame = new_frame
	)

func _shake():
	var origin = animated_sprite.position
	var tween = get_tree().create_tween()
	tween.tween_method(func(t): 
		animated_sprite.position = origin + \
			20 * pow(2, -.1*t) * sin(t)  * Vector2.RIGHT,
		0, 10 * PI, .5
	)
	tween.tween_callback(func(): animated_sprite.position = Vector2.ZERO)
	tween.play()
