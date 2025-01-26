class_name Attacker
extends Area2D

signal attack_started(target: Attackable, damage: int)

@export var is_custom_attack = false

var is_attacking: bool:
	get:
		return _current_target != null
var attack_damage := 1
var attack_cooldown := 1.0:
	set(v):
		attack_cooldown = v
		_attack_timer.wait_time = v
var current_target: Attackable:
	get:
		return _current_target
	set(v):
		push_error("Don't set current_target")
		return

var _current_target: Attackable = null
@onready var _attack_timer: Timer = $AttackTimer


func _ready() -> void:
	_attack_timer.timeout.connect(_attack_current_target)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	
func _attack_current_target():
	if !_current_target: return
	attack_started.emit(_current_target, attack_damage)
	if !is_custom_attack:
		_current_target.hp -= attack_damage
	
	
func _on_area_entered(area: Area2D):
	if _current_target != null: return
	if area is Attackable and area.hp > 0:
		start_attack(area)


func _on_area_exited(area: Area2D):
	if area is not Attackable: return
	area = area as Attackable
	if area == _current_target:
		_current_target = null
		_attack_timer.stop()
		area.died.disconnect(find_new_target)


func start_attack(attackable: Attackable):
	_current_target = attackable
	_attack_timer.start()
	attackable.died.connect(find_new_target)


func find_new_target():
	stop_attack()
	for a in get_overlapping_areas():
		if a is Attackable and a.hp > 0:
			start_attack(a)
			return

func stop_attack():
	_current_target = null
