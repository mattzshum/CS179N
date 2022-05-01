extends Enemies

var moveSpeed = 50

var base_cooldown = 1
var curr_cooldown = 0

const beam = preload("res://LaserBeam.tscn")
var beamSpeed = 400
func _physics_process(delta):
	curr_cooldown -= delta
	# Send a beam every second
	if atk_target != null and curr_cooldown < 0:
		curr_cooldown = base_cooldown

		var b = beam.instance()
		b.vel = forward * beamSpeed

		b.ignore = [self, b]

		get_parent().add_child(b)
		b.set_global_transform(get_global_transform())
		b.rotation_degrees = rotation_degrees
