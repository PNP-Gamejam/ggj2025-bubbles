extends Node2D

@export var hp := 1500
const SPEED = 70.0

@onready var base_position: Vector2 = get_tree().get_first_node_in_group("base").global_position
@onready var _attackable: Attackable = $Attackable
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _death_audio: AudioStreamPlayer = $DeathAudioStreamPlayer
@onready var _hurt_audio: AudioStreamPlayer = $HurtAudioStreamPlayer
@onready var _visible_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var _fall_back_timer: Timer = $FallBackTimer
@onready var _missile_spawn_position: Marker2D = $MissileSpawnPosition
@onready var backup_missile_timer: Timer = $BackupMissileTimer

const MISSILE = preload("res://scenes/projectiles/missile.tscn")
const DISTANCE_BEFORE_SHOOT = 700.0

enum State { WALK, SHOOT, FALLBACK }
var state: State = State.WALK

func _ready() -> void:
	_attackable.max_hp = hp
	_attackable.hp = hp
	_attackable.hp_changed.connect(func():
		if _attackable.hp > 0:
			_hurt_audio.play()
	)
	_attackable.died.connect(func():
		animated_sprite.play("death")
		_attackable.set_deferred("input_pickable", false)
		_attackable.set_deferred("monitorable", false)
		_death_audio.play()
		await get_tree().create_timer(3.0).timeout
		queue_free()
	)
	GlobalBus.game_over.connect(func():
		animated_sprite.play("default")
		set_process(false)
	)
	
	backup_missile_timer.timeout.connect(_spawn_missiles)
	_fall_back_timer.timeout.connect(_start_walk)
	_start_walk()
	
	
func _spawn_missiles():
	for i in range(4):
		await get_tree().create_timer(1.0).timeout
		var missile = MISSILE.instantiate()
		missile.global_position = base_position +\
			Vector2.RIGHT.rotated(randf() * TAU) * Constants.SPAWN_RADIUS
		missile.look_at(base_position)
		get_tree().current_scene.add_child(missile)
	
	
func _start_shoot():
	state = State.SHOOT
	animated_sprite.play("attack")
	for i in range(2):
		await get_tree().create_timer(2.0).timeout
		var missile = MISSILE.instantiate()
		missile.global_position = _missile_spawn_position.global_position
		missile.look_at(base_position)
		get_tree().current_scene.add_child(missile)
	await get_tree().create_timer(3.0).timeout
	_start_fallback()


func _start_fallback():
	animated_sprite.play("walk")
	state = State.FALLBACK
	_fall_back_timer.start()


func _start_walk():
	animated_sprite.play("walk")
	state = State.WALK
	global_position = base_position +\
		Vector2.RIGHT.rotated(randf() * TAU) * Constants.SPAWN_RADIUS
	

func _process(delta: float) -> void:
	if _attackable.hp <= 0:
		return
	look_at(base_position)
	rotate(-PI/2)
	if state == State.WALK:
		global_position -= base_position.direction_to(global_position) * SPEED * delta
		if base_position.distance_to(global_position) <= DISTANCE_BEFORE_SHOOT:
			_start_shoot() 
	elif state == State.FALLBACK:
		global_position += base_position.direction_to(global_position) * SPEED / 2.0 * delta
		
	
		
