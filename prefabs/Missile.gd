extends KinematicBody

var velo = Vector3(0, 0, 1)
var explo = preload("res://prefabs/LargeExplosion.res")
var dropping = false
var speed = 0
export (int) var max_speed
export (float) var acceleration
export (float) var rotationSpeed
export (int) var drop_speed

func _ready():
	$Timer.start(1)
	dropping = true


func _physics_process(delta):
	if dropping:
		var down_velo = Vector3(0, -drop_speed, 0)
# warning-ignore:return_value_discarded
		move_and_slide(down_velo)
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
		transform = transform.interpolate_with(new_pos, rotationSpeed * delta)
		velo = translation.direction_to(target_pos)
	
	translation = translation - transform.basis.z * speed * delta
	
	if transform.origin.z < -300:
		queue_free()


func _on_Area_body_entered(body):
	if body.is_in_group("Enemies") or body.is_in_group("Bullets"):
		if (body.is_in_group("Enemies")):
			body.health -= 6
		else:
			body.queue_free()
		
		for node in get_tree().get_nodes_in_group("Enemies"):
			if (node.translation.distance_to(translation) < 6):
				node.health -= 1
				
		queue_free()


func _on_Timer_timeout():
	$Engine.restart()
	dropping = false
