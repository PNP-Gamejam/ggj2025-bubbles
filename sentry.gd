extends Node2D

@export var BULLET: PackedScene 
@export var hp := 70
@export var attack_damage := 15
@export var attack_cooldown := 0.5

@onready var _attackable: Attackable = $Attackable
@onready var _attacker: Attacker = $Attacker
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet_spawn_position: Marker2D = $BulletSpawnPosition

@onready var shoot_audio: AudioStreamPlayer = $ShootAudioStreamPlayer
@onready var destroyed_audio: AudioStreamPlayer = $DestroyedAudioStreamPlayer
@onready var spawn_audio: AudioStreamPlayer = $SpawnAudioStreamPlayer

@onready var spawn_particles: GPUParticles2D = $SpawnParticles2D

func _ready() -> void:
	spawn_audio.play()
	spawn_particles.emitting = true
	_attackable.max_hp = hp
	_attackable.hp = hp
	_attackable.died.connect(func():
		destroyed_audio.play()
		await destroyed_audio.finished
		queue_free()
	)
	_attacker.attack_damage = attack_damage
	_attacker.attack_cooldown = attack_cooldown
	_attacker.attack_started.connect(_on_attack_started)

func _on_attack_started(_target: Attackable, damage: int):
	var bullet = BULLET.instantiate() as Bullet
	animated_sprite.play("attack")
	while animated_sprite.frame <= 6:
		await animated_sprite.frame_changed
	shoot_audio.play()
	bullet.rotation = rotation
	bullet.global_position = bullet_spawn_position.global_position
	bullet.damage = damage
	get_tree().current_scene.add_child(bullet)
	animated_sprite.play("default")


func _process(delta: float) -> void:
	if _attacker.current_target:
		look_at(_attacker.current_target.global_position)
