class_name Attackable
extends Area2D

@export var max_hp := 10
@onready var _hp = max_hp

var hp: set = _set_hp, get = _get_hp

signal hp_changed
signal died

func _ready() -> void:
	input_event.connect(_on_input_event)

func _set_hp(v: float):
	_hp = clamp(v, 0, max_hp)
	hp_changed.emit()
	if _hp <= 0:
		died.emit()

func _get_hp():
	return _hp

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('click_attack'):
			var damage_clicker = get_tree().get_first_node_in_group("damage_clicker") as DamageClicker
			damage_clicker.on_click(self)
