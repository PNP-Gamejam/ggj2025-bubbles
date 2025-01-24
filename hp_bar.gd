extends Sprite2D

@export var _attackable: Attackable

func _ready() -> void:
	var mat = material as ShaderMaterial
	mat.set_shader_parameter("hp", _attackable.hp)
	mat.set_shader_parameter("max_hp", _attackable.max_hp)
	_attackable.hp_changed.connect(
		func ():
			mat.set_shader_parameter("hp", _attackable.hp)
			mat.set_shader_parameter("max_hp", _attackable.max_hp)
	)
