class_name Boid
extends Area2D

var nearby_boids: Array[Boid] = []

func _ready() -> void:
	area_exited.connect(_on_area_exited)
	area_entered.connect(_on_area_entered)

func _process(delta: float):
	for x in nearby_boids:
		var nearby_distance = x.global_position - self.global_position
		owner.global_position -= nearby_distance * delta * .2

func _on_area_entered(area: Area2D):
	if area is Boid:
		nearby_boids.append(area)
	
func _on_area_exited(area: Area2D):
	if area is Boid:
		nearby_boids.erase(area)
		
