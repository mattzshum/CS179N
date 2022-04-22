extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = null
var motion = Vector2.ZERO
onready var space_motion = Vector2(0,0)
var speed = 5

var actor = self
var inside = false
var charge = false
var touch = false


onready var vel = Vector2(0, 0)
onready var turn = 0

#func intialize(actor):
#	self.actor = actor

#func _physics_process(delta):
#	global_translate(vel * delta)
#	rotation_degrees += turn * delta
#	var vector_up = -get_global_transform().orthonormalized().y
#	vel += vector_up * delta * 240

func _physics_process(delta):
	var vector_up = -get_global_transform().orthonormalized().y
	if player:
		if inside == false:
			$Sprite.set_frame(0)
			charge = false
			motion = (player.global_position - global_position).normalized() * 1
			#space_motion += vector_up * delta * 200
			actor.rotation = (player.global_position - actor.global_position).normalized().angle() + 1.57 
		if inside == true:
			#space_motion += vector_up * delta * 150
			actor.rotation = (player.global_position - actor.global_position).normalized().angle() + 1.57
			if charge == false:
				motion = (player.global_position - global_position).normalized().rotated(PI/2) * 5
				$AnimationPlayer.play("Charge")
			if charge == true:
				motion = (player.global_position - global_position).normalized() * 5
				$AnimationPlayer.play("fully charged")
	else:
		motion = Vector2.ZERO
		#motion = global_position.normalized() * 2
		#motion = vector_up * delta * 300
		#actor.rotation = (player.global_position - actor.global_position).normalized().angle() + 1.57
	#global_translate(space_motion * delta)
	motion = move_and_collide(motion)




func _on_DetectionZone_body_entered(body):
	if body != self:
		#print("entered")
		player = body
		inside = true


func _on_DetectionZone_body_exited(body):
	#print("exited")
	inside = false
	#player = null



func _on_AnimationPlayer_animation_finished(anim_name):
	
	if anim_name == "Charge":
		charge = true
	if anim_name == "fully charged":
		charge = false
