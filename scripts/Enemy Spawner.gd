extends Spatial

onready var main = get_tree().current_scene
var Enemy = preload("res://prefabs/Tie Fighter.res")
var Boss = preload("res://prefabs/LightCruiser.res")

func spawn():
	var enemy = Enemy.instance()
	main.add_child(enemy)
	enemy.transform.origin = transform.origin + Vector3(rand_range(-10, 10), rand_range(-6, 6), 0)
	
func spawn_boss():
	var boss = Boss.instance()
	main.add_child(boss)
	boss.transform.origin = transform.origin + Vector3(0, 0, -20)


func _on_Timer_timeout():
	spawn()


func _on_Boss_timeout():
	spawn_boss()
	$Timer.stop()
