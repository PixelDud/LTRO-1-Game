extends KinematicBody2D

var velocity = Vector2.ZERO

export var playerNumber = 0
export var moveSpeed = 60
export var health = 100
export var rightDash = 0
export var leftDash = 0

# up = "p" + str(playerNumber) + "Up"
# down = "p" + str(playerNumber) + "Down"
# left = "p" + str(playerNumber) + "Left"
# right = "p" + str(playerNumber) + "Right"
# b = "p" + str(playerNumber) + "B"
# a = "p" + str(playerNumber) + "A"
# start = "p" + str(playerNumber) + "Start"

onready var healthBar = get_parent().get_node("p" + str(playerNumber) + "Health")
onready var dashAudioCue = $dashAudioCue
onready var commandTimer = $commandTimer

func _physics_process(_delta):
	movement_input()
	command_input()
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
		velocity.x = 0
	elif Input.is_action_pressed("p" + str(playerNumber) + "Left"):
		print("Left!")
		moveSpeed = 30
		velocity.x -= moveSpeed
	elif Input.is_action_pressed("p" + str(playerNumber) + "Right"):
		print("Right!")
		moveSpeed = 60
		velocity.x += moveSpeed
	else:
		velocity.x = 0
		
		
#trying to implement dashes and shit but its tough rn, your code makes sense but i'm just struggling 
#cause i don't know enough
func command_input():
	if Input.is_action_just_pressed("p" + str(playerNumber) + "Right"):
		commandTimer.start()
		rightDash += 1
	elif Input.is_action_just_pressed("p" + str(playerNumber) + "Left"):
		commandTimer.start()
		leftDash += 1
	if rightDash >= 2:
		dashAudioCue.play()
		position.x += 50
		print("dash")
		rightDash = 0
	if leftDash >= 2:
		dashAudioCue.play()
		position.x -= 30
		print("dash")
		leftDash = 0
func _on_Commandtimer_timeout():
	rightDash = 0
	leftDash = 0