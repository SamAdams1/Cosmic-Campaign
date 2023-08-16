extends Control

func _input(event):
	if event.is_action_pressed("attack") and self.visible == true:
		self.visible = false
		get_tree().paused = false
