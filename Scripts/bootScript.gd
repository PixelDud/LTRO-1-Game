extends Node2D

func _ready():
	$Viewport/BootSound.play()
	$Viewport/BootAnim.play("boot")

func _physics_process(delta):
	yield(get_tree().create_timer(4), "timeout")
	print("Boot Completed")
	get_tree().change_scene("res://Scenes/gameMenu.tscn")
