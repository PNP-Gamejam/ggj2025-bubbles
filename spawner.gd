extends Node2D

const BOSS = preload("res://scenes/boss.tscn")

@export var monster_scenes: Array = []
@onready var monster_timer: Timer = $MonsterTimer
@onready var boss_timer: Timer = $BossTimer

var monster_cooldown_time := 2.0

func _ready() -> void:
	monster_timer.timeout.connect(_spawn_random)
	boss_timer.timeout.connect(_spawn_boss)
	
	
func _spawn_boss() -> void:
	monster_timer.wait_time = monster_cooldown_time * 2.0
	var boss = BOSS.instantiate()
	boss.global_position = Vector2(9999,9999)
	get_tree().current_scene.add_child(boss)
	
	
func _spawn_random() -> void:
	var scene = monster_scenes.pick_random()
	var monster = scene.instantiate() as Node2D
	monster.global_position = global_position +\
		Vector2.RIGHT.rotated(randf()*TAU) *\
		Constants.SPAWN_RADIUS
	monster.look_at(Vector2.ZERO)
	monster.rotate(-PI)
	get_tree().current_scene.add_child(monster)
