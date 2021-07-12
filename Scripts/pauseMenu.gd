extends Control

func _input(event):
	if event.is_action_pressed("p1Start") or event.is_action_pressed("p2Start"):
		pause(not get_tree().paused)


func _on_Resume_pressed():
	pause(false)


func _on_Exit_pressed():
	get_tree().quit()


func pause(state):
		var paused = state
		get_tree().paused = paused
		visible = paused
