extends Spatial

export (float) var maxSpeed 
export (float) var acceleration
export (float) var maxCooldown
export (float) var maxMissileCooldown
export (int) var maxHealth
export (int) var maxEnergy
export (float) var energyRegen
export (int) var bulletEnergy
export (int) var missileEnergy

var health = 0
var energy = 0

onready var guns = [$"Delta Fighter/Gun 1", $"Delta Fighter/Gun 2"]
onready var timer = $Timer
onready var camera = $Camera
onready var ship = $"Delta Fighter"
onready var sound = $"Delta Fighter/AudioStreamPlayer3D"
onready var main = get_tree().current_scene

var Bullet = preload("res://prefabs/Bullet.res")
var Missile = preload("res://prefabs/Missile.res")

var inputDir = Vector3()
var velocity = Vector3()
var cooldown = 0
var missileCooldown = 1

func _ready():
	health = maxHealth
	energy = maxEnergy


# warning-ignore:unused_argument
func _physics_process(delta):
	inputDir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	inputDir.y = Input.get_action_strength("up") - Input.get_action_strength("down")
	
	velocity.x = move_toward(velocity.x, inputDir.x * maxSpeed, acceleration)
	velocity.y = move_toward(velocity.y, inputDir.y * maxSpeed, acceleration)
	
	ship.rotation_degrees.z = -velocity.x
	ship.rotation_degrees.x = velocity.y
	ship.rotation_degrees.y = -velocity.x
	
	ship.move_and_slide(velocity)
		
	ship.transform.origin.x = clamp(ship.transform.origin.x, -15, 15)
	ship.transform.origin.y = clamp(ship.transform.origin.y, -8, 10)
	
func _process(delta):
	if cooldown > 0:
		cooldown -= delta
		
	if missileCooldown > 0:
		missileCooldown -= delta
		
	if health < maxHealth:
		health += delta / 8
		
	if Input.is_action_pressed("fire bullet") and cooldown <= 0 \
			and energy > bulletEnergy:
		energy -= bulletEnergy
		cooldown = maxCooldown * delta
		for i in guns:
			var bullet = Bullet.instance()
			main.add_child(bullet)
			bullet.transform = i.global_transform
			bullet.velo = bullet.transform.basis.z * -600
			sound.play()
			
	if Input.is_action_pressed("fire missile") and missileCooldown <= 0 \
			and energy > missileEnergy:
		energy -= missileEnergy
		missileCooldown = maxMissileCooldown * delta
		for i in guns:
			var missile = Missile.instance()
			main.add_child(missile)
			missile.transform = $"Delta Fighter/Missile Tube".global_transform
			
	if energy < maxEnergy:
		energy += energyRegen * delta
	energy = clamp(energy, 0, maxEnergy)
		
		
