extends KinematicBody

var velo = Vector3(0, 0, 200)
var explo = preload("res://prefabs/MiniExplosion.res")

func _ready():
	print("Created")
	
func _physics_process(_delta):
# warning-ignore:return_value_discarded
	move_and_slide(velo)
	
	if transform.origin.z > 30:
		queue_free()


func _on_Area_body_entered(body):
	if body.get_parent().is_in_group("Players"):
		body.get_parent().health -= 0.5
		var ex = explo.instance()
		ex.transform = transform
		ex.explode()
		get_tree().current_scene.add_child(ex)
		queue_free()

