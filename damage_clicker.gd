class_name DamageClicker
extends Node

@export var base_damage := 1
@export var DAMAGE_STACKER: PackedScene

func on_click(attackable: Attackable):
	var damage_stacker := attackable.get_node("DamageStacker") as DamageStacker
	if damage_stacker == null:
		damage_stacker = DAMAGE_STACKER.instantiate() as DamageStacker
		damage_stacker.base_damage = base_damage
		damage_stacker.attackable = attackable
		attackable.add_child(damage_stacker)
	damage_stacker.count += 1
