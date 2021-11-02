extends Spatial

var achievements
var upgrades
var game = preload("res://scenes/Space.tscn")

export (NodePath) var fighterPath
export (float) var rotateSpeed
onready var fighter = get_node(fighterPath)

func _ready():
	$Panel.show()
	$LoadingScreen.hide()


# warning-ignore:unused_argument
func _process(delta):
	if (Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()
		
	# fighter.rotation_degrees.y += delta * rotateSpeed
		
	


func _on_play_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(game)


func _on_upgrades_pressed():
	pass


func _on_achievements_pressed():
	pass


func _on_quit_pressed():
	get_tree().quit()
