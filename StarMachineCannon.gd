extends Sprite


var vel : Vector2 setget set_vel, get_vel
onready var parent : Node2D = get_parent()
func get_vel():
	return parent.vel
func set_vel(vel):
	parent.vel = vel


export(float) var beamCooldown = 6
const beamInterval = 12
func _process(delta):
	beamCooldown = max(0, beamCooldown - delta)
	if beamCooldown == 0: # and parent.attackable > 0:
		$Anim.play("Fire")
		beamCooldown = beamInterval
signal on_destroyed(Node2D)
var hp = 600
var hp_max = 600
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp == 0:
		destroy()
func destroy():
	emit_signal("on_destroyed", self)
	queue_free()
	
const sword = preload("res://StarMachineSword.tscn")
func deploy_sword():
	var s = sword.instance()
	var swarm = parent.get_parent()
	swarm.add_child(s)
	swarm.register(s)
	swarm.get_parent().register(s)
	s.global_position = global_position
	s.global_rotation = global_rotation
	s.global_scale = global_scale
	s.vel = parent.vel
	s.player = parent.player
	s.ignore = parent.ignore
	parent.ignore.append(s)
	destroy()

func _on_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Projectile"):
		if actor.ignore.has(self):
			return
		damage(actor)

const projectile = preload("res://CrescentBlast.tscn")
func fire():
	var b = projectile.instance() as Node2D
	b.ignore = parent.ignore
	b.ignore.append(b)
	parent.get_parent().get_parent().add_child(b)
	b.global_rotation = global_rotation
	b.global_position = $BeamOrigin.global_position
	b.vel = vel + polar2cartesian(720, global_rotation)
