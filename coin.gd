extends Area2D

var amount := 5
var picked := false

@onready var pick_audio: AudioStreamPlayer = $PickAudioStreamPlayer
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	input_event.connect(on_input_event)

func on_input_event(v: Node, event: InputEvent, s: int):
	if event is InputEventMouseButton:
		if event.is_pressed():
			pick()
	
	
func pick():
	if picked: return
	picked = true
	GlobalBus.money_dropped.emit(amount)
	GlobalBus.target_clicked.emit()
	pick_audio.play()
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(.1, .1), .8)
	tween.tween_property(sprite, "position", Vector2(0, -200), .8)
	tween.tween_property(self, "self_modulate", Color.TRANSPARENT, .8)
	tween.play()
	await tween.finished
	queue_free()
