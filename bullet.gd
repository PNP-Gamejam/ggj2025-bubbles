class_name Bullet
extends Area2D

var damage := 1
const SPEED = 300.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	if area is Attackable:
		area.hp -= damage
		queue_free()

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * delta * SPEED
