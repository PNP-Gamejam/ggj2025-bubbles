extends Camera2D

func _ready() -> void:
	GlobalBus.health_threshold_reached.connect(_shake)
	
func _shake():
	var origin = position
	var tween = get_tree().create_tween()
	tween.tween_method(func(t): 
		position = origin + \
			10 * pow(2, -.1*t) * sin(t)  * Vector2.RIGHT.rotated(randf()*TAU),
		0, 10 * PI, .5
	)
	tween.tween_callback(func(): position = origin)
	tween.play()

	
