class_name Common
var vel = Vector2(0, 0)
var turn = 0

var hp = 100
var energy = 100
var fuel = 100

var fuelUsage = 1.0/90
var thrustSpeed = 240
var turnSpeed = 180

var owner

var animBody
var animLeftLeg
var animRightLeg

# time remaining before weapon is ready
# if negative, indicates excess time that has passed (used for battery recharge)
var fireCooldown = 0

func canFire(): return fireCooldown < 0

func _init(owner: Node2D, animBody: AnimationPlayer, animLeftLeg: AnimationPlayer, animRightLeg: AnimationPlayer):
	self.owner = owner
	self.animBody = animBody
	self.animLeftLeg = animLeftLeg
	self.animRightLeg = animRightLeg
func update_physics(delta):
	owner.global_translate(vel * delta)
	owner.rotation_degrees += turn * delta
	vector_up = -owner.get_global_transform().orthonormalized().y
func update_systems(delta):
	damageDelay -= delta
	fireCooldown -= delta
	if fireCooldown < 0:
		var rechargeRate = 10 - fireCooldown*5
		var inc = min(100 - energy, delta * rechargeRate)
		if inc >= 0:
			energy += inc
			fuel -= inc / 90
var damageDelay = 0
func damage(attacker):
	if damageDelay > 0:
		return
	var d = attacker.damage
	hp -= d
	damageDelay = 1
var vector_up
func update_controls(delta):
	var up = Input.is_key_pressed(KEY_UP)
	var left = Input.is_key_pressed(KEY_LEFT)
	var right = Input.is_key_pressed(KEY_RIGHT)
	if up:
		fuel -= fuelUsage
		if left == right:
			vel += vector_up * delta * thrustSpeed
			animLeftLeg.play("Thrust")
			animRightLeg.play("Thrust")
		elif left:
			turn -= delta * turnSpeed / 2
			vel += vector_up * delta * thrustSpeed * 3/4
			animLeftLeg.play("Thrust")
			animRightLeg.play("Turn")
		elif right:
			turn += delta * turnSpeed / 2
			vel += vector_up * delta * thrustSpeed * 3/4
			animLeftLeg.play("Turn")
			animRightLeg.play("Thrust")
	elif left and right:
		fuel -= fuelUsage
		vel += vector_up * delta * thrustSpeed
		animLeftLeg.play("Turn")
		animRightLeg.play("Turn")
	elif left:
		fuel -= fuelUsage / 2
		turn -= delta * turnSpeed
		animLeftLeg.play("Idle")
		animRightLeg.play("Turn")
	elif right:
		fuel -= fuelUsage / 2
		turn += delta * turnSpeed
		animLeftLeg.play("Turn")
		animRightLeg.play("Idle")
	else:
		animLeftLeg.play("Idle")
		animRightLeg.play("Idle")
