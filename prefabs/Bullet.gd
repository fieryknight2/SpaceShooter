extends KinematicBody

var velo = Vector3()
var explo = preload("res://prefabs/MiniExplosion.res")

func _physics_process(_delta):
# warning-ignore:return_value_discarded
	move_and_slide(velo)
	
	if (transform.origin.z < -600):
		queue_free()


func _on_Area_body_entered(body):
	if body.is_in_group("Enemies"):
		body.health -= 1
		var ex = explo.instance()
		ex.transform = transform
		ex.explode()
		get_tree().current_scene.add_child(ex)
		queue_free()
