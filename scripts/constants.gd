extends Node

const SPAWN_RADIUS = 1200
const SENTRY_MARGIN = 120
var EMPTY_FUNC := func(): pass

func has_sentry_nearby(pos: Vector2):
	var sentries = get_tree().get_nodes_in_group("sentry")
	return sentries.any(func(s: Node2D): 
		return s.global_position.distance_to(pos) <= Constants.SENTRY_MARGIN
	)
