extends KinematicBody2D

var velocity = Vector2.ZERO

export var playerNumber = 0
export var health = 100
export var moveSpeed = 60
export var backSpeed = 30
export var forwardsDashDefault = 50
export var backDashDefault = 25
var forwardsDash = forwardsDashDefault
var backDash = backDashDefault
var rightDashDir = Vector2(1,0)
var leftDashDir = Vector2(-1,0)
var rightDash = 0
var leftDash = 0
var canDash = true
var isDashing = false
var inputTimeout = 0.5
var dashCooldown = 0.7
var canAttack = true

# up = "p" + str(playerNumber) + "Up"
# down = "p" + str(playerNumber) + "Down"
# left = "p" + str(playerNumber) + "Left"
# right = "p" + str(playerNumber) + "Right"
# b = "p" + str(playerNumber) + "B"
# a = "p" + str(playerNumber) + "A"
# start = "p" + str(playerNumber) + "Start"

onready var healthBar = get_parent().get_node("p" + str(playerNumber) + "Health")
onready var dashAudioCue = $dashAudioCue

func _physics_process(_delta):
	getHitCheck()
	movement_input()
	dash_input()
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
		if (playerNumber == 2):
			velocity.x -= moveSpeed
		else:
			velocity.x -= backSpeed
	elif Input.is_action_pressed("p" + str(playerNumber) + "Right"):
		print("Right!")
		if (playerNumber == 2):
			velocity.x += backSpeed
		else:
			velocity.x += moveSpeed
	else:
		velocity.x = 0

func dash_input():
	if Input.is_action_just_pressed("p" + str(playerNumber) + "Right") :
		rightDash += 1
		yield(get_tree().create_timer(inputTimeout), "timeout")
	elif Input.is_action_just_pressed("p" + str(playerNumber) + "Left"):
		leftDash += 1
		yield(get_tree().create_timer(inputTimeout), "timeout")
	if rightDash >= 2 and canDash:
		canDash = false
		isDashing = true
		dashRight(position.x)
		yield(get_tree().create_timer(dashCooldown), "timeout")
		canDash = true
	if leftDash >= 2 and canDash:
		canDash = false
		isDashing = true
		dashLeft(position.x)
		yield(get_tree().create_timer(dashCooldown), "timeout")
		canDash = true

func dashRight(currentPos):
	print("Dash!")
	if (playerNumber == 2):
		while (currentPos != currentPos + backDash):
			position.x = lerp(currentPos, currentPos + backDash, 0.25)
			backDash -= backDash/0.25
		isDashing = false
		backDash = backDashDefault
	else:
		while (currentPos != currentPos + forwardsDash):
			position.x = lerp(currentPos, currentPos + forwardsDash, 0.25)
			forwardsDash -= forwardsDash/0.25
		isDashing = false
		forwardsDash = forwardsDashDefault
	rightDash = 0

func dashLeft(currentPos):
	print("Dash!")
	if (playerNumber == 2):
		while (currentPos != currentPos - forwardsDash):
			position.x = lerp(currentPos, currentPos - forwardsDash, 0.25)
			forwardsDash -= forwardsDash/0.25
		isDashing = false
		forwardsDash = forwardsDashDefault
	else:
		while (currentPos != currentPos - backDash):
			position.x = lerp(currentPos, currentPos - backDash, 0.25)
			backDash -= backDash/0.25
		isDashing = false
		backDash = backDashDefault
	leftDash = 0

func getHitCheck():
	# use areas instead
	pass
