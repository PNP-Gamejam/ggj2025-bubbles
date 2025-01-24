extends Node2D

@export var attack_damage := 1
@export var attack_cooldown := 1.0

@onready var _attackable: Attackable = $Attackable
@onready var _attacker: Attacker = $Attacker
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	_attacker.attack_damage = attack_damage
	_attacker.attack_cooldown = attack_cooldown
	_attacker.target_attacked.connect(func():
		animated_sprite.play("attack")
		await animated_sprite.animation_finished
		animated_sprite.play("default")
	)


func _process(delta: float) -> void:
	if _attacker.current_target:
		look_at(_attacker.current_target.global_position)
