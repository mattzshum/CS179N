extends Node2D
const score = 800
var bossName = "Thunder Drone"
var vel = Vector2(0, 0)

var time_scale = 1.0
func set_time_scale(t:float):
	time_scale = t
	$Anim.playback_speed = t

func _ready():
	$Anim.connect("animation_finished", self, "_on_animation_finished")
	call_deferred("register_player")
	
	
signal on_destroyed
var player
func register_player():
	player = get_parent().player
	
var trailTime = 0
func _physics_process(delta):
	delta *= time_scale
	trailTime -= delta
	if trailTime < 0:
		trailTime = 0.1
	if player:
		
		var speed = 180 * delta
		var offset = (player.global_position - global_position)
		if $Anim.current_animation == "Waiting":
			if offset.length_squared() > 240 * 240:
				var rejection = vel * (1 - vel.normalized().dot(offset.normalized()))
				vel -= rejection.normalized() * min(rejection.length(), speed)
				
				
				vel += offset.normalized() * min(speed, 240 - vel.length())
			else:
				$Anim.play("Charging")
		if $Anim.current_animation == "Charging":
			vel -= vel.normalized() * speed / 2
			
			if offset.length_squared() > 180 * 180:
				vel += offset.rotated(PI/4).normalized() * speed
			else:
				vel += offset.rotated(PI/2).normalized() * speed
		elif $Anim.current_animation == "Ready":
			var rejection = vel * (1 - vel.normalized().dot(offset.normalized()))
			vel -= rejection.normalized() * min(rejection.length(), speed)
			vel += offset.normalized() * speed
		elif $Anim.current_animation == "Recovering":
			vel -= vel / 60
		
	global_translate(vel * delta)
func _on_animation_finished(name):
	if name == "Charging":
		$Anim.play("Ready")
	elif name == "Ready":
		flashes = 3
		start_flash()
	elif name == "Flashing":
		flashes -= 1
		if flashes > 0:
			start_flash()
		else:
			$Anim.play("Recovering")
	elif name == "Recovering":
		$Anim.play("Waiting")
var beam = preload("res://LightningBeam.tscn")
func fire_salvo_1():
	var ignore = [self]
	for angle in [0, PI/2, PI, PI * 1.5]:
		var l = beam.instance()
		
		l.vel = vel + polar2cartesian(480, angle)
		
		ignore.append(l)
		l.ignore = ignore
		
		get_parent().add_child(l)
		l.set_global_transform(get_global_transform())
		l.rotation += angle
func fire_salvo_2():
	var ignore = [self]
	for angle in [0, PI/2, PI, PI * 1.5]:
		angle += PI/4
		
		var l = beam.instance()
		l.vel = vel + polar2cartesian(480, angle)
		
		ignore.append(l)
		l.ignore = ignore
		
		get_parent().add_child(l)
		l.set_global_transform(get_global_transform())
		l.rotation += angle
var flashes = 3
func start_flash():
	
	if flashes == 3:
		vel += (player.global_position - global_position).normalized() * 240
	else:
		vel = (player.global_position - global_position).normalized() * vel.length()
	$Anim.play("Flashing")
func _on_Detect_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		player = actor
var damage = 30
var drain = 60
func _on_Damage_area_entered(area):
	if $Anim.current_animation != "Flashing":
		return
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		flashes = 0
		$Dash.play()
		actor.damage(self)
		
		var velDiff = vel - actor.common.vel
		actor.common.vel += 2 * velDiff / 2
		
		vel = -vel
onready var hp_max = [600, 1200, 1800][PlayerVariables.difficulty]
onready var hp = hp_max
func damage(projectile):
	hp -= projectile.damage
	if hp < 1:
		emit_signal("on_destroyed", self)
		queue_free()
