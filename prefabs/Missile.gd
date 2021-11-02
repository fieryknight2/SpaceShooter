extends KinematicBody

var velo = Vector3(0, 0, 1)
var explo = preload("res://prefabs/GiantExplosion.res")
var dropping = false
var speed = 0
export (int) var max_speed
export (float) var acceleration
export (float) var rotationSpeed
export (int) var maxDropSpeed
export (float) var dropAccel
export (float) var dropTime
var dropSpeed = 0

func _ready():
	$Timer.start(dropTime)
	dropping = true


func _physics_process(delta):
	if dropping:
		if dropSpeed < maxDropSpeed:
			dropSpeed += dropAccel * delta
		dropSpeed = clamp(dropSpeed, 0, maxDropSpeed)
		
		var down_velo = Vector3(0, -dropSpeed, 0)
		rotation.x += delta / 4
		
		translation -= transform.basis.z * down_velo * delta
		return
		
	if (speed < max_speed):
		speed += acceleration
		speed = clamp(speed, 0, max_speed)
		
	var nearest = null
	var distance = 1000
	for node in get_tree().get_nodes_in_group("Enemies"):
		if (node.translation.distance_to(translation) < distance):
			nearest = node
			distance = node.translation.distance_to(translation)
	
	if (nearest != null):
		var target_pos = nearest.translation
		var new_pos = transform.looking_at(target_pos, Vector3.UP)
		transform = transform.interpolate_with(new_pos, rotationSpeed * delta * (speed/max_speed))
		velo = translation.direction_to(target_pos)
	
	translation = translation - transform.basis.z * speed * delta
	
	if transform.origin.z < -300:
		queue_free()


func _on_Area_body_entered(body):
	if body.is_in_group("Enemies") or body.is_in_group("Bullets"):
		if (body.is_in_group("Enemies")):
			body.health -= 15
		else:
			body.queue_free()
		
		for node in get_tree().get_nodes_in_group("Enemies"):
			for i in [30, 25, 20, 15, 10, 5]:
				if (node.translation.distance_to(translation) < i):
					get_tree().current_scene.CurrentScore += 1
					node.health -= 1
					
		var ex = explo.instance()
		get_tree().current_scene.add_child(ex)
		ex.transform = transform
		ex.explode()
				
		queue_free()


func _on_Timer_timeout():
	$Engine.restart()
	dropping = false
