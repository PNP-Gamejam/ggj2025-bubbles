extends Node2D
class_name Shooter

@export var BULLET: PackedScene 
@export var bullet_damage: float = 5.0

func shoot():
	var bullet = BULLET.instantiate() as Bullet
	bullet.rotation = global_rotation
	bullet.global_position = global_position
	bullet.damage = bullet_damage
	get_tree().current_scene.add_child(bullet)
