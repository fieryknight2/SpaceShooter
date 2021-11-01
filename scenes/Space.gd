extends Spatial

onready var fighter = $"Delta Fighter"
onready var spawner = $"Enemy Spawner"
onready var health = $Control/Health
onready var energy = $Control/Energy
onready var finished = $Control/Finished

# Called when the node enters the scene tree for the first time.
func _ready():
	finished.hide()
	
	health.max_value = fighter.maxHealth
	health.value = fighter.maxHealth
	
	energy.max_value = fighter.maxEnergy
	energy.value = fighter.maxEnergy
	
# warning-ignore:unused_argument
func _process(delta):
	if (finished.visible == false):
		health.value = fighter.health
		energy.value = fighter.energy
	
		if (fighter.health <= 0):
			energy.value = 0
			fighter.queue_free()
			finished.show()
			finished.get_child(0).play("Open Finished Panel")
			
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()



func _on_Button_pressed():
	get_tree().quit()
