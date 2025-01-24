extends Sprite2D

@export var _attackable: Attackable

func _process(delta: float) -> void:
	var mat = material as ShaderMaterial
	mat.set_shader_parameter("hp", _attackable.hp)
	mat.set_shader_parameter("max_hp", _attackable.max_hp)
