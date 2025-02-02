extends Node2D
var vel setget, get_vel
var fireCooldown setget, get_fire_cooldown
var hp setget, get_hp
var energy setget, get_energy
var fuel setget, get_fuel
func get_vel(): return common.vel
func get_fire_cooldown(): return common.fireCooldown
func get_hp(): return common.hp
func get_energy(): return common.energy
func get_fuel(): return common.fuel
onready var common = load("res://Characters/Common.gd").new(self, $Anim, $LeftLeg/Anim, $RightLeg/Anim)

func set_time_scale(t):
	#return
	common.set_time_scale(t)

const primaryFireInterval = 0.2
const secondaryFireInterval = 2.5
const primaryEnergyUse = 5
const secondaryEnergyUse = 50
var fireCount = 0

const beam = preload("res://CrescentBeam.tscn")
const blast = preload("res://CrescentBlast.tscn")
func _process(delta):
	common.update_systems(delta)
	common.update_controls(delta)
	if common.state != common.State.Active:
		return
	if common.is_control_pressed(KEY_X) && common.canFire() && common.energy > primaryEnergyUse:
		$PrimaryAttack.play()
		common.energy -= primaryEnergyUse
		common.fireCooldown = primaryFireInterval
		fireCount += 1
		
		var p = [$GunLeft, $GunRight][fireCount%2]
		
		var l = beam.instance()
		l.ignore = [self]
		l.vel = common.vel + common.vector_up * 512 * 3 / 4.0
		get_parent().add_child(l)
		l.set_global_transform(p.get_global_transform())
		l.rotation_degrees = rotation_degrees - 90
	if common.is_control_pressed(KEY_Z) && common.canFire() && common.energy > secondaryEnergyUse:
		$SecondaryAttack.play()
		common.energy -= secondaryEnergyUse
		common.fireCooldown = secondaryFireInterval
		$Anim.play("Cast")
func _physics_process(delta):
	common.update_physics(delta)
func fire_beam():
	var p = [$GunLeft, $GunRight][fireCount%2]
	fireCount += 1
	var l = beam.instance()
	l.ignore.append(self)
	l.vel = common.vel + common.vector_up * 512
	get_parent().add_child(l)
	l.set_global_transform(p.get_global_transform())
	l.rotation_degrees = rotation_degrees - 90
	
var beamAccel = preload("res://CrescentBeamAccel.tscn")
func fire_blast():
	var p = $BeamOrigin
	var l = blast.instance()
	l.ignore.append(self)
	l.vel = common.vel + common.vector_up * 750
	get_parent().add_child(l)
	l.set_global_transform(p.get_global_transform())
	l.rotation_degrees = rotation_degrees - 90
	
	if common.is_control_pressed(KEY_X) and common.energy > primaryEnergyUse:
		common.energy -= primaryEnergyUse
		
		var e = Helper.create_projectile(
			beamAccel,
			get_parent(),
			[self],
			$BeamOrigin.global_position,
			common.vel,
			randf() * PI * 2)

func _on_body_animation_finished(name):
	if name == "Cast":
		$Anim.play("Idle")


func _on_area_entered(area):
	pass # Replace with function body.


func _on_body_entered(area):
	pass # Replace with function body.
	
func damage(projectile):
	common.damage(projectile)
	
func add_fuel(f, fm):
	common.add_fuel(f, fm)
	
func add_hp(h, hm):
	common.add_hp(h, hm)
	
func add_energy(e, em):
	common.add_energy(e, em)
