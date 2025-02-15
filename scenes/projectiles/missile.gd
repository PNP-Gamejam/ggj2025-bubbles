class_name Missile
extends Area2D

@export var hp := 20
var damage := 10
const SPEED = 100.0
var is_destroying = false

@onready var impact_particles: GPUParticles2D = $GPUParticles2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var impact_audio: AudioStreamPlayer = $ImpactAudioStreamPlayer
@onready var trail_particles_2d: GPUParticles2D = $TrailParticles2D
@onready var attackable: Attackable = $Attackable
@onready var destroy_timer: Timer = $DestroyTimer

func _ready() -> void:
	attackable.max_hp = hp
	attackable.hp = hp
	area_entered.connect(_on_area_entered)
	attackable.died.connect(_destroy_self)
	destroy_timer.timeout.connect(queue_free)
	trail_particles_2d.emitting = true


func _on_area_entered(area: Area2D):
	if area is Attackable and area != attackable:
		area.hp -= damage
		_destroy_self()


func _destroy_self():
	if is_destroying: return
	is_destroying = true
	sprite_2d.hide()
	set_deferred("monitoring", false)
	impact_particles.restart()
	impact_audio.play()
	await impact_particles.finished
	queue_free()


func _physics_process(delta: float) -> void:
	if is_destroying: return
	position += Vector2.RIGHT.rotated(rotation) * delta * SPEED
