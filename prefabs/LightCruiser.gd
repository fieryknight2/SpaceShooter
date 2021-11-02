extends KinematicBody

var speed
var currentGun = 0
var gunCount = 6
var explo = preload("res://prefabs/GiantExplosion.res")
var Bullet = preload("res://prefabs/ParticleBullet.res")
var slide = Vector2(0, 0)
export (float) var health
export (int) var slide_speed

onready var timer = $Timer
onready var main = get_tree().current_scene
onready var guns = [$"Guns/Gun 1", $"Guns/Gun 2", $"Guns/Gun 3", 
					$"Guns/Gun 4", $"Guns/Gun 5", $"Guns/Gun 6"]

func _ready():
	speed = rand_range(10, 20)
	timer.start(0.1)
	$Timer2.start(2)
	
func _physics_process(_delta):
# warning-ignore:return_value_discarded
	move_and_slide(Vector3(slide.x * slide_speed, slide.y * slide_speed, speed));

func _process(_delta):
	transform.origin.x = clamp(transform.origin.x, -10, 10)
	transform.origin.y = clamp(transform.origin.y, -6, 8)
	if transform.origin.z > 30:
		queue_free();
	if health <= 0:
		main.CurrentScore += 250
		main.EnemiesDefeated += 1
		var ex = explo.instance()
		ex.transform = transform
		ex.explode()
		get_tree().current_scene.add_child(ex)
		get_tree().current_scene.get_node("EnemySpawner/Timer").start()
		queue_free()


func _on_Timer_timeout():
	var bullet = Bullet.instance()
	main.add_child(bullet)
	bullet.transform = guns[currentGun].global_transform
	bullet.velo = bullet.transform.basis.z * -300
	
	currentGun += 1
	if (currentGun >= gunCount):
		currentGun = 0
	
func _on_Area_body_entered(body):
	var p = body.get_parent()
	if p.is_in_group("Players"):
		var t = health
		health -= p.health
		p.health -= t


func _on_Timer2_timeout():
	slide.x = rand_range(-1, 1)
	slide.y = rand_range(-1, 1)
	$Timer2.start(4)
