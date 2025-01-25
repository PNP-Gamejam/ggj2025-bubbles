extends Node2D

const SPAWN_RADIUS = 1200

@export var monster_scenes: Array[PackedScene] = []
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_spawn_random)


func _spawn_random() -> void:
	var scene = monster_scenes.pick_random()
	var monster = scene.instantiate() as Node2D
	monster.global_position = global_position + Vector2.RIGHT.rotated(randf()*TAU) * SPAWN_RADIUS
	monster.look_at(Vector2.ZERO)
	monster.rotate(-PI)
	get_tree().current_scene.add_child(monster)
