extends Area2D

@export var hp := 55

@export var SPEED := 300.0
@export var attack_damage := 1
@export var attack_cooldown := 1.0

@onready var _attack_timer: Timer = $AttackTimer
@onready var _attackable: Attackable = $Attackable

var _current_target: Attackable = null

func _ready() -> void:
	_attackable.max_hp = hp
	_attack_timer.wait_time = attack_cooldown
	_attack_timer.timeout.connect(_attack_current_target)
	_attackable.died.connect(func(): queue_free())
	#_attackable.hp_changed.connect(func(): print("%s current hp %d" % [name, _attackable.hp]))
	if _attackable.input_pickable:
		_attackable.input_event.connect(_on_input_event)
	area_entered.connect(_on_area_entered)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('click_attack'):
			var damage_clicker = get_tree().get_first_node_in_group("damage_clicker") as DamageClicker
			damage_clicker.on_click(_attackable)
	
	
func _attack_current_target():
	if !_current_target: return
	_current_target.hp -= attack_damage
	
	
func _on_area_entered(area: Area2D):
	if area is Attackable:
		_current_target = area
		_attack_timer.start()
		area.died.connect(func (): _current_target = null)
	
	
func _process(delta: float) -> void:
	if !_current_target:
		var base = get_tree().get_first_node_in_group("base") as Node2D
		var dir = global_position.direction_to(base.global_position)
		global_position += SPEED * dir * delta
	
