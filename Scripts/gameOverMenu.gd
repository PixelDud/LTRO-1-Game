extends Control

onready var player1 = get_node("/root/World/Viewport/Player")
onready var player2 = get_node("/root/World/Viewport/Player2")

func _input(event):
	if player1.health <= 0 or player2.health <= 0:
		pause(true)


func _on_Restart_pressed():
	get_tree().reload_current_scene()


func _on_Exit_pressed():
	get_tree().quit()


func pause(state):
		var paused = state
		get_tree().paused = paused
		visible = paused
