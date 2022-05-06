extends Node2D
var extents = 900
export(int) var count = 20
const beacon = preload("res://BossBeacon.tscn")
func get_rand():
	return rand_range(-extents, extents)
func _ready():
	var points = []
	for i in range(20 * 10):
		if len(points) == count:
			break
		var good = true
		var v = Vector2(get_rand(), get_rand())	
		for other in points:
			if v.distance_to(other) < 60:
				good = false
				break
		if !good:
			continue
		points.append(v)
		var b = beacon.instance()
		add_child(b)
		b.global_position = v
