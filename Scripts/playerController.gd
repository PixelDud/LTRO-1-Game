extends KinematicBody2D

var velocity = Vector2.ZERO

export var flipSprite = false
export var playerNumber = 0
export var health = 200
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
var attackCooldown = 0.332
var specialCooldown = 0.332
var dashCooldown = 0.7
var canAttack = true
var attackDir = "right"
var block = "not"
# up = "p" + str(playerNumber) + "Up"
# down = "p" + str(playerNumber) + "Down"
# left = "p" + str(playerNumber) + "Left"
# right = "p" + str(playerNumber) + "Right"
# b = "p" + str(playerNumber) + "B"
# a = "p" + str(playerNumber) + "A"
# start = "p" + str(playerNumber) + "Start"
onready var sprite = $Sprite
onready var healthBar = get_parent().get_node("p" + str(playerNumber) + "Health")
onready var dashAudioCue = $dashAudioCue

func _physics_process(_delta):
	$Sprite.flip_h = flipSprite
	
	getHitCheck()
	movement_input()
#	dash_input()
	attackCheck()
	healthBar.value = health
	
	if (healthBar.value <= 0):
		print("I'm dead!")
	
	if Input.is_action_just_pressed("ui_focus_next"):
		health -= 5
	
	velocity = velocity.normalized() * moveSpeed
	velocity = move_and_slide(velocity, Vector2.UP)

func movement_input():
	sprite.animation = "default"
	if Input.is_action_pressed("p" + str(playerNumber) + "Up"):
		print("Up!")
		attackDir = "Up"
		velocity.x = 0 
		block = "not"
	elif Input.is_action_pressed("p" + str(playerNumber) + "Down"):
		print("Down!")
		velocity.x = 0
		attackDir = "Down"
		block = "Down"
		sprite.animation = "block"
	elif Input.is_action_pressed("p" + str(playerNumber) + "Left"):
		print("Left!")
		attackDir = "Left"
		if (playerNumber == 2):
			velocity.x -= moveSpeed
			block = "not"
		else:
			velocity.x -= backSpeed
			block = "Standing"
	elif Input.is_action_pressed("p" + str(playerNumber) + "Right"):
		print("Right!")
		attackDir = "Right"
		if (playerNumber == 2):
			velocity.x += backSpeed
			block = "Standing"
		else:
			velocity.x += moveSpeed
			block = "not"
	else:
		attackDir = "Right"
		velocity.x = 0

#func dash_input():
#	if Input.is_action_just_pressed("p" + str(playerNumber) + "Right") :
#		rightDash += 1
#		yield(get_tree().create_timer(inputTimeout), "timeout")
#	elif Input.is_action_just_pressed("p" + str(playerNumber) + "Left"):
#		leftDash += 1
#		yield(get_tree().create_timer(inputTimeout), "timeout")
#	if rightDash >= 2 and canDash:
#		canDash = false
#		isDashing = true
#		dashRight(position.x)
#		yield(get_tree().create_timer(dashCooldown), "timeout")
#		canDash = true
#	if leftDash >= 2 and canDash:
#		canDash = false
#		isDashing = true
#		dashLeft(position.x)
#		yield(get_tree().create_timer(dashCooldown), "timeout")
#		canDash = true
#
#func dashRight(currentPos):
#	print("Dash!")
#	if (playerNumber == 2):
#		while (currentPos != currentPos + backDash):
#			position.x = lerp(currentPos, currentPos + backDash, 0.25)
#			backDash -= backDash/0.25
#		isDashing = false
#		backDash = backDashDefault
#	else:
#		while (currentPos != currentPos + forwardsDash):
#			position.x = lerp(currentPos, currentPos + forwardsDash, 0.25)
#			forwardsDash -= forwardsDash/0.25
#		isDashing = false
#		forwardsDash = forwardsDashDefault
#	rightDash = 0
#
#func dashLeft(currentPos):
#	print("Dash!")
#	if (playerNumber == 2):
#		while (currentPos != currentPos - forwardsDash):
#			position.x = lerp(currentPos, currentPos - forwardsDash, 0.25)
#			forwardsDash -= forwardsDash/0.25
#		isDashing = false
#		forwardsDash = forwardsDashDefault
#	else:
#		while (currentPos != currentPos - backDash):
#			position.x = lerp(currentPos, currentPos - backDash, 0.25)
#			backDash -= backDash/0.25
#		isDashing = false
#		backDash = backDashDefault
#	leftDash = 0

func getHitCheck():
	# use areas
	pass
	
func attackCheck():
	
	if Input.is_action_just_pressed("p" + str(playerNumber) + "A") and canAttack and attackDir == "Up":
		print("Up Attack!")
		canAttack = false
		moveSpeed = 0
		yield(get_tree().create_timer(attackCooldown), "timeout")
		moveSpeed = 60
		canAttack = true
		print("Can attack now.")
	if Input.is_action_just_pressed("p" + str(playerNumber) + "A") and canAttack and attackDir == "Left":
		print("Left Attack!")
		canAttack = false
		moveSpeed = 0
		yield(get_tree().create_timer(attackCooldown), "timeout")
		moveSpeed = 60
		canAttack = true
		print("Can attack now.")
	if Input.is_action_just_pressed("p" + str(playerNumber) + "A") and canAttack and attackDir == "Right":
		print("Right Attack!")
		canAttack = false
		moveSpeed = 0
		yield(get_tree().create_timer(attackCooldown), "timeout")
		moveSpeed = 60
		canAttack = true
		print("Can attack now.")
	if Input.is_action_just_pressed("p" + str(playerNumber) + "A") and canAttack and attackDir == "Down":
		print("Down Attack!")
		canAttack = false
		moveSpeed = 0
		yield(get_tree().create_timer(attackCooldown), "timeout")
		moveSpeed = 60
		canAttack = true
		print("Can attack now.")
	
	#if Input.is_action_pressed("p" + str(playerNumber) + "A") and canAttack:
	#	if Input.is_action_just_pressed("p" + str(playerNumber) + "Up"):
	#		print("Up Attack!")
	#		canAttack = false
	#		yield(get_tree().create_timer(attackCooldown), "timeout")
	#		canAttack = true
	#		print("Can attack now.")
	#	if Input.is_action_just_pressed("p" + str(playerNumber) + "Down"):
	#		print("Down Attack!")
	#		canAttack = false
	#		yield(get_tree().create_timer(attackCooldown), "timeout")
	#		canAttack = true
	#		print("Can attack now.")
	#	if Input.is_action_just_pressed("p" + str(playerNumber) + "Left"):
	#		print("Left Attack!")
	#		canAttack = false
	#		yield(get_tree().create_timer(attackCooldown), "timeout")
	#		canAttack = true
	#		print("Can attack now.")
	#	if Input.is_action_just_pressed("p" + str(playerNumber) + "Right"):
	#		print("Right Attack!")
	#		canAttack = false
	#		yield(get_tree().create_timer(attackCooldown), "timeout")
	#		canAttack = true
	#		print("Can attack now.")
	
	#if Input.is_action_pressed("p" + str(playerNumber) + "B") and canAttack:
		#if Input.is_action_just_pressed("p" + str(playerNumber) + "Up"):
			#print("Up Special!")
			#canAttack = false
			#yield(get_tree().create_timer(specialCooldown), "timeout")
			#canAttack = true
			#print("Can special attack now.")
		#if Input.is_action_just_pressed("p" + str(playerNumber) + "Down"):
		#	print("Down Special!")
		#	canAttack = false
		#	yield(get_tree().create_timer(specialCooldown), "timeout")
		#	canAttack = true
		#	print("Can special attack now.")
		#if Input.is_action_just_pressed("p" + str(playerNumber) + "Left"):
		#	print("Left Special!")
		#	canAttack = false
		#	yield(get_tree().create_timer(specialCooldown), "timeout")
		#	canAttack = true
		#	print("Can special attack now.")
		#if Input.is_action_just_pressed("p" + str(playerNumber) + "Right"):
		#	print("Right Special!")
		#	canAttack = false
		#	yield(get_tree().create_timer(specialCooldown), "timeout")
		#	canAttack = true
		#	print("Can special attack now.")
