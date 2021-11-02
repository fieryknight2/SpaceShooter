extends KinematicBody

export (int) var speed
var explo = preload("res://prefabs/GiantExplosion.res")
var mexplo = preload("res://prefabs/LargeExplosion.res")

var health = 0

func _ready():
	health = rand_range(2, 4)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _physics_process(delta):
# warning-ignore:return_value_discarded
	move_and_slide(Vector3(0, 0, speed))
	
	$Asteroid.rotation_degrees.x += 1
	$Asteroid.rotation_degrees.y += 1
	$Asteroid.rotation_degrees.z -= 1
	
	if health <= 0:
		get_tree().current_scene.AsteroidsDestroyed += 1
		get_tree().current_scene.CurrentScore += 25
		
		var ex = mexplo.instance()
		ex.transform = transform
		ex.explode()
		get_tree().current_scene.add_child(ex)
		
		queue_free()
		
		
	if transform.origin.z > 30:
		queue_free()


func _on_Area_body_entered(body):
	if body.is_in_group("Enemies"):
		var ex = mexplo.instance()
		ex.transform = transform
		ex.explode()
		get_tree().current_scene.add_child(ex)
		queue_free()
		
	if body.get_parent().is_in_group("Players"):
		get_tree().current_scene.AsteroidsDestroyed += 1
		get_tree().current_scene.CurrentScore += 25
		body.get_parent().health -= health * 3
		
		var ex
		if health > 1:
			ex = explo.instance()
		else:
			ex = mexplo.instance()
		ex.transform = transform
		ex.explode()
		get_tree().current_scene.add_child(ex)
		queue_free()
		
