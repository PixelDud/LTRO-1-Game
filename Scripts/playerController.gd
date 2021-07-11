extends KinematicBody2D

var velocity = Vector2.ZERO

export var playerNumber = 0
export var moveSpeed = 120
export var health = 100

# up = "p" + str(playerNumber) + "Up"
# down = "p" + str(playerNumber) + "Down"
# left = "p" + str(playerNumber) + "Left"
# right = "p" + str(playerNumber) + "Right"
# b = "p" + str(playerNumber) + "B"
# a = "p" + str(playerNumber) + "A"
# start = "p" + str(playerNumber) + "Start"

onready var healthBar = get_parent().get_node("p" + str(playerNumber) + "Health")

func _physics_process(_delta):
	movement_input()
	
	healthBar.value = health
	
	if (healthBar.value <= 0):
		print("I'm dead!")
	
	if Input.is_action_just_pressed("ui_focus_next"):
		health -= 5
	
	velocity = velocity.normalized() * moveSpeed
	velocity = move_and_slide(velocity, Vector2.UP)

func movement_input():
	if Input.is_action_pressed("p" + str(playerNumber) + "Up"):
		print("Up!")
	elif Input.is_action_pressed("p" + str(playerNumber) + "Down"):
		print("Down!")
	elif Input.is_action_pressed("p" + str(playerNumber) + "Left"):
		print("Left!")
		velocity.x -= moveSpeed
	elif Input.is_action_pressed("p" + str(playerNumber) + "Right"):
		print("Right!")
		velocity.x += moveSpeed
	else:
		velocity.x = 0
