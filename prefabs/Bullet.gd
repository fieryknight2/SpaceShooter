extends KinematicBody

var velo = Vector3()
var explo = preload("res://prefabs/MiniExplosion.res")

func _physics_process(_delta):
# warning-ignore:return_value_discarded
	move_and_slide(velo)
	
	if (transform.origin.z < -600):
		queue_free()


func _on_Area_body_entered(body : Node):
	if body.is_in_group("Enemies"):
		body.health -= 1
		
		get_tree().current_scene.CurrentScore += 5
		var ex = explo.instance()
		ex.transform = transform
		ex.explode()
		get_tree().current_scene.add_child(ex)
		queue_free()
		
	elif body.is_in_group("Asteroids"):
		body.health -= 1
		
		get_tree().current_scene.CurrentScore += 2
		var ex = explo.instance()
		ex.transform = transform
		ex.explode()
		get_tree().current_scene.add_child(ex)
		queue_free()

