class_name DamageStacker
extends Sprite2D

var base_damage := 0
var count := 0:
	set(v):
		if v > 0:
			stack_audio.pitch_scale = (1.0 / (1.0 + pow(2, -1 * count))) + .5
			stack_audio.play()
		count = v
var wait_time := 1.0
var attackable: Attackable = null


@onready var label: Label = $Label
@onready var timer: Timer = $Timer
@onready var hit_particles: GPUParticles2D = $HitParticles2D
@onready var bubble_sprite: Sprite2D = $BubbleSprite
@onready var hit_audio: AudioStreamPlayer = $HitAudioStreamPlayer
@onready var stack_audio: AudioStreamPlayer = $StackAudioStreamPlayer


func _ready() -> void:
	assert(attackable != null)
	timer.wait_time = wait_time
	timer.timeout.connect(func ():
		attackable.hp -= base_damage * count
		bubble_sprite.hide()
		hit_particles.restart()
		timer.stop()
		label.hide()
		count = -99999
		hit_audio.play()
		await hit_particles.finished
		queue_free()
	)
	timer.start()
	
	
func _process(delta: float) -> void:
	var mat = material as ShaderMaterial
	bubble_sprite.scale = Vector2.ONE * ((1.0 / (1.0 + pow(2, -1 * count))) - .5)
	label.text = "x %d" % count
	mat.set_shader_parameter("current_time", timer.wait_time - timer.time_left)
	mat.set_shader_parameter("wait_time", timer.wait_time)
