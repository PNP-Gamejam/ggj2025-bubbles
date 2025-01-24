extends Area2D

@export var SPEED := 300.0
@export var attack_damage := 1
@export var attack_cooldown := 1.0
@onready var attack_timer: Timer = $AttackTimer

var current_target: Attackable = null

func _ready() -> void:
	attack_timer.wait_time = attack_cooldown
	attack_timer.timeout.connect(_attack_current_target)
	area_entered.connect(_on_area_entered)
	
	
func _attack_current_target():
	if !current_target: return
	current_target.hp -= attack_damage
	
	
func _on_area_entered(area: Area2D):
	if area is Attackable:
		current_target = area
		attack_timer.start()
		area.died.connect(func (): current_target = null)
	
	
func _process(delta: float) -> void:
	if !current_target:
		var base = get_tree().get_first_node_in_group("base") as Node2D
		var dir = global_position.direction_to(base.global_position)
		global_position += SPEED * dir * delta
	
