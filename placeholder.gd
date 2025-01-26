extends Sprite2D


func _input(event: InputEvent) -> void:
	if texture == null: return
	if event is InputEventMouseMotion:
		global_position = event.position
		look_at(get_viewport_rect().get_center())
		if !(texture.resource_path.contains("Heavy") or texture.resource_path.contains("Triple")):
			rotate(PI)
		else:
			rotate(PI/2)
