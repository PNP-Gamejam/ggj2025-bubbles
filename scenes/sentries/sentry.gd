extends Node2D

@export var hp := 70
@export var attack_damage := 15
@export var attack_cooldown := 0.5

@onready var _attackable: Attackable = $Attackable
@onready var _attacker: Attacker = $Attacker

@onready var destroyed_audio: AudioStreamPlayer = $DestroyedAudioStreamPlayer
@onready var spawn_audio: AudioStreamPlayer = $SpawnAudioStreamPlayer

@onready var _spawn_particles: GPUParticles2D = $SpawnParticles2D
@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _shoot_audio: AudioStreamPlayer = $ShootAudioStreamPlayer

func _ready() -> void:
	spawn_audio.play()
	_spawn_particles.emitting = true
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
	for c in get_children():
		if c is Shooter: c.bullet_damage = attack_damage
	
func _on_attack_started(_target: Attackable, _damage: float):
	_animated_sprite.play("attack")
	while _animated_sprite.frame <= 6:
		await _animated_sprite.frame_changed
	for c in get_children():
		if c is Shooter: c.shoot()
	_shoot_audio.play()

func _process(delta: float) -> void:
	if _attacker.current_target:
		look_at(_attacker.current_target.global_position)
