extends KinematicBody


var speed
var explo = preload("res://prefabs/LargeExplosion.res")
var Bullet = preload("res://prefabs/Bullet-Enemy.res")
export (float) var health

onready var timer = $Timer
onready var main = get_tree().current_scene

func _ready():
	speed = rand_range(20, 50)
	timer.start(3)
	
func _physics_process(_delta):
# warning-ignore:return_value_discarded
	move_and_slide(Vector3(0, 0, speed));

func _process(_delta):
	if transform.origin.z > 30:
		queue_free();
	if health <= 0:
		main.CurrentScore += 50
		main.EnemiesDefeated += 1
		var ex = explo.instance()
		ex.transform = transform
		ex.explode()
		get_tree().current_scene.add_child(ex)
		
		queue_free()


func _on_Timer_timeout():
	var bullet = Bullet.instance()
	main.add_child(bullet)
	bullet.transform = transform
	bullet.velo = bullet.transform.basis.z * 200


func _on_Area_body_entered(body):
	var p = body.get_parent()
	if p.is_in_group("Players"):
		p.health -= health
		main.CurrentScore += 25
		main.EnemiesDefeated += 1
		var ex = explo.instance()
		ex.transform = transform
		ex.explode()
		get_tree().current_scene.add_child(ex)
		
		queue_free()
