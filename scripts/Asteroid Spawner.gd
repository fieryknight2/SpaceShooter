extends Spatial

onready var main = get_tree().current_scene
var Asteroid = preload("res://prefabs/Asteroid.res")

func spawn():
	var asteroid = Asteroid.instance()
	main.add_child(asteroid)
	asteroid.transform.origin = transform.origin + Vector3(rand_range(-10, 10), rand_range(-6, 6), 0)


func _on_Timer_timeout():
	spawn()

