class_name Bullet
extends Area2D

var damage := 1
const SPEED = 300.0

@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var destroy_timer: Timer = $DestroyTimer

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	destroy_timer.timeout.connect(queue_free)

func _on_area_entered(area: Area2D):
	if area is Attackable:
		area.hp -= damage
		sprite_2d.hide()
		particles.restart()
		audio_stream_player.play()
		await particles.finished
		queue_free()

func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * delta * SPEED
