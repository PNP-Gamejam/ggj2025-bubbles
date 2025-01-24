extends Node2D

@export var BULLET: PackedScene 
@export var attack_damage := 1
@export var attack_cooldown := 1.0

@onready var _attackable: Attackable = $Attackable
@onready var _attacker: Attacker = $Attacker
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet_spawn_position: Marker2D = $BulletSpawnPosition


func _ready() -> void:
	_attacker.attack_damage = attack_damage
	_attacker.attack_cooldown = attack_cooldown
	_attacker.attack_started.connect(_on_attack_started)

func _on_attack_started(_target: Attackable, damage: int):
	var bullet = BULLET.instantiate() as Bullet
	animated_sprite.play("attack")
	while animated_sprite.frame <= 6:
		await animated_sprite.frame_changed
	bullet.rotation = rotation
	bullet.global_position = bullet_spawn_position.global_position
	bullet.damage = damage
	get_tree().current_scene.add_child(bullet)
	animated_sprite.play("default")


func _process(delta: float) -> void:
	if _attacker.current_target:
		look_at(_attacker.current_target.global_position)
