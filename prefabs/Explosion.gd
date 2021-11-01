extends Spatial

func _process(_delta):
	if not $smoke.emitting:
		queue_free()
	
func explode():
	$heat.restart()
	$fire.restart()
	$smoke.restart()
	$audio.play()

