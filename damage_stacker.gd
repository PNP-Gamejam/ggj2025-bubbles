class_name DamageStacker
extends Sprite2D

var base_damage := 0
var count := 0
var wait_time := 1.0
var attackable: Attackable = null


@onready var label: Label = $Label
@onready var timer: Timer = $Timer


func _ready() -> void:
	assert(attackable != null)
	timer.wait_time = wait_time
	timer.timeout.connect(func ():
		attackable.hp -= base_damage * count
		queue_free()
	)
	timer.start()
	
func _process(delta: float) -> void:
	var mat = material as ShaderMaterial
	label.text = "x %d" % count
	mat.set_shader_parameter("current_time", timer.wait_time - timer.time_left)
	mat.set_shader_parameter("wait_time", timer.wait_time)
