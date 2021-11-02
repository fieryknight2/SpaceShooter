extends Spatial

onready var fighter = $"Delta Fighter"
onready var spawner = $"Enemy Spawner"
onready var health = $Control/Health
onready var energy = $Control/Energy
onready var finished = $Control/Finished
onready var score = $Control/Score
var lost = false

var CurrentScore = 0
var EnemiesDefeated = 0
var AsteroidsDestroyed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	finished.hide()
	
	health.max_value = fighter.maxHealth
	health.value = fighter.maxHealth
	
	energy.max_value = fighter.maxEnergy
	energy.value = fighter.maxEnergy
	
# warning-ignore:unused_argument
func _process(delta):
	score.text = "Score: " + String(CurrentScore)
	if not lost:
		health.value = fighter.health
		energy.value = fighter.energy
	
		if (fighter.health <= 0):
			energy.value = 0
			fighter.die()
			lost = true
			finished.show()
			finished.get_child(0).play("Open Finished Panel")
			$Control/Finished/AsteroidsDestroyed.text = "Asteroids Destroyed: " + String(AsteroidsDestroyed)
			$Control/Finished/EnemiesDefeated.text = "Enemies Defeated: " + String(EnemiesDefeated)
			$Control/Finished/TotalScore.text = "Total Score: " + String(CurrentScore)
			
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()



func _on_Button_pressed():
	get_tree().quit()


func _on_Restart_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
