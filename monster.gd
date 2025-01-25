extends Node2D

@export var attack_damage := 1
@export var attack_cooldown := 1.0
@export var hp := 55
@export var SPEED := 300.0
@export var bounty := 50 

@onready var _attackable: Attackable = $Attackable
@onready var _attacker: Attacker = $Attacker
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _boid: Boid = $Boid
@onready var _death_audio: AudioStreamPlayer = $DeathAudioStreamPlayer
@onready var _hurt_audio: AudioStreamPlayer = $HurtAudioStreamPlayer

func _ready() -> void:
	_attacker.attack_cooldown = attack_cooldown
	_attacker.attack_damage = attack_damage
	_attackable.max_hp = hp
	_attackable.hp = hp
	_attackable.hp_changed.connect(func():
		if _attackable.hp > 0:
			_play_tint_animation()
			_hurt_audio.play()
	)
	_attackable.died.connect(func():
		animated_sprite.play("death")
		_death_audio.play()
		_attacker.stop_attack()
		GlobalBus.money_dropped.emit(bounty)
		await get_tree().create_timer(3.0).timeout
		queue_free()
	)
	if _attackable.input_pickable:
		_attackable.input_event.connect(_on_input_event)
	GlobalBus.game_over.connect(func():
		animated_sprite.play("default")
		set_process(false)
	)
	_boid.owner = owner
	animated_sprite.material = preload("res://resources/tint_material.tres").duplicate()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('click_attack'):
			var damage_clicker = get_tree().get_first_node_in_group("damage_clicker") as DamageClicker
			damage_clicker.on_click(_attackable)
	

func _process(delta: float) -> void:
	if _attackable.hp <= 0:
		return
	var base = get_tree().get_first_node_in_group("base") as Node2D
	look_at(base.global_position)
	rotation += -PI/2
	if !_attacker.is_attacking:
		var dir = global_position.direction_to(base.global_position)
		owner.global_position += SPEED * dir * delta
		animated_sprite.play("walk")
	else:
		animated_sprite.play("attack")
	
func _play_tint_animation():
	var mat = animated_sprite.material as ShaderMaterial
	var tween = get_tree().create_tween()
	tween.tween_method(func(t): 
		mat.set_shader_parameter("amount", .6 * abs(sin(t))),
		0.0, TAU, .7
	)
	tween.tween_callback(func(): mat.set_shader_parameter("amount", 0))
	tween.play()
