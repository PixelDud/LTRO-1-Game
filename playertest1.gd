extends KinematicBody2D

var moveSpeed = 120
var health = 100
var velocity = Vector2.ZERO

onready var healthBar = get_parent().get_node("healthBar")

func _physics_process(delta):
	get_input()
	
	healthBar.value = health
	if (healthBar.value <= 0):
		self.queue_free()
	
	velocity = velocity.normalized() * moveSpeed
	velocity = move_and_slide(velocity, Vector2.UP)

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("p1Left"):
		velocity.x += (moveSpeed/2) * -1
	elif Input.is_action_pressed("p1Right"):
		velocity.x += moveSpeed
	elif Input.is_action_pressed("p1Down"):
		pass
	elif Input.is_action_pressed("p1Up"):
		pass
	if Input.is_action_just_pressed("ui_focus_next"):
		health -= 5
