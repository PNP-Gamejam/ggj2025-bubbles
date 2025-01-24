class_name DamageStacker
extends Sprite2D

var base_damage := 0
var count := 0
var wait_time := 3.0
var attackable: Attackable = null

@onready var label: Label = $Label
@onready var timer := Timer.new()

func _ready() -> void:
	assert(attackable != null)
	add_child(timer)
	timer.timeout.connect(func ():
		attackable.hp -= base_damage * count
		queue_free()
	)
	timer.start()
	
func _process(delta: float) -> void:
	var mat = material as ShaderMaterial
	label.text = "x %d" % count
	mat.set_shader_parameter("current_time", timer.wait_time - timer.time_left)
	mat.set_shader_parameter("wait_timer", timer.wait_time)
