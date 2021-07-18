extends KinematicBody2D

var velocity = Vector2.ZERO

export var flipSprite = false
export var playerNumber = 0
export var health = 200
export var moveSpeed = 1
export var backSpeed = 2
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
var moveBoxes = false
var recovery = false
var hitType = "nothing"
var hitStun = 0
#hitType is for deciding whether a move hits low, medium, or high
#moveBoxes is for when a move has its hitboxes active
#recovery is when you are recovering from doing a move

# up = "p" + str(playerNumber) + "Up"
# down = "p" + str(playerNumber) + "Down"
# left = "p" + str(playerNumber) + "Left"
# right = "p" + str(playerNumber) + "Right"
# b = "p" + str(playerNumber) + "B"
# a = "p" + str(playerNumber) + "A"
# start = "p" + str(playerNumber) + "Start"
onready var hurtbox = $Collision
onready var forwardKickBox = $HitBoxes/ForwardKick
onready var lowKickBox = $HitBoxes/Lowkick
onready var sprite = $Sprite
onready var healthBar = get_parent().get_node("p" + str(playerNumber) + "Health")
onready var dashAudioCue = $dashAudioCue

func _physics_process(_delta):
	$Sprite.flip_h = flipSprite
	
	getHitCheck()
	animation_handler()
	if hitStun == 0:
		movement_input()
#		dash_input()
		attackCheck()
	if hitStun >= 1:
		hitStun -= 1
		$Sprite.animation = "takehit"
	healthBar.value = health
	
	if (healthBar.value <= 0):
		print("I'm dead!")
	
	if Input.is_action_just_pressed("ui_focus_next"):
		health -= 5
		hitStun += 10
	
	velocity = move_and_slide(velocity, Vector2.DOWN)

func movement_input():
	if canAttack:
		#sprite.animation = "idle"
		hurtbox.position.x = 0.118 
		hurtbox.position.y = -1.006
		hurtbox.shape.extents = Vector2(9,24)
	if Input.is_action_pressed("p" + str(playerNumber) + "Up"):
		print("Up!")
		attackDir = "Up"
		block = "not"
	elif Input.is_action_pressed("p" + str(playerNumber) + "Down"):
		print("Down!")
		attackDir = "Down"
		block = "Down"
		if canAttack:
			sprite.animation = "block"
			hurtbox.position.x = 0.118 
			hurtbox.position.y = 8.253
			hurtbox.shape.extents = Vector2(9,15)
	elif Input.is_action_pressed("p" + str(playerNumber) + "Left"):
		print("Left!")
		attackDir = "Left"
		if (playerNumber == 2):
			position.x -= moveSpeed 
			block = "not"
		else:
			position.x -= backSpeed * 0.3
			block = "Standing"
	elif Input.is_action_pressed("p" + str(playerNumber) + "Right"):
		print("Right!")
		attackDir = "Right"
		if (playerNumber == 1):
			position.x += moveSpeed
			block = "not"
		else:
			position.x += backSpeed * 0.3
			block = "Standing"
	else:
		pass
func animation_handler():
	if Input.is_action_pressed("p" + str(playerNumber) + "Left"):
		if (playerNumber == 2):
			$Sprite.play("walk")
		else:
			$Sprite.play("shuffle")
	elif Input.is_action_pressed("p" + str(playerNumber) + "Right"):
		if (playerNumber == 2):
			$Sprite.play("shuffle")
		else:
			$Sprite.play("walk")
	else:
		$Sprite.play("idle")

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

#stats
#damage: down a = 20, forward a = 25, back a = 15 + 15, up a = 40

func _on_Collision_area_entered(area):
	print("enter")

func getHitCheck():
	pass
	
func attackCheck():
	if Input.is_action_just_pressed("p" + str(playerNumber) + "A") and canAttack and attackDir == "Up":
		print("Up Attack!")
		canAttack = false
		backSpeed = 0
		moveSpeed = 0
		print("Startup...")
		position.x += -3
		yield(get_tree().create_timer(0.36666667), "timeout")
		print("Hitbox...")
		velocity.x += 300
		moveBoxes = true
		yield(get_tree().create_timer(0.05), "timeout")
		moveBoxes = false
		recovery = true
		print("Recovery")
		velocity.x -= 250
		yield(get_tree().create_timer(0.25), "timeout")
		recovery = false
		velocity.x = 0
		backSpeed = 2
		moveSpeed = 1
		canAttack = true
		print("Can attack now.")
	if Input.is_action_just_pressed("p" + str(playerNumber) + "A") and canAttack and attackDir == "Left":
		print("Left Attack!")
		canAttack = false
		backSpeed = 0
		moveSpeed = 0
		print("Startup...")
		yield(get_tree().create_timer(0.20), "timeout")
		print ("Hitboxes")
		moveBoxes = true
		yield(get_tree().create_timer(0.03333), "timeout")
		print("Hitboxes, again")
		yield(get_tree().create_timer(0.03333), "timeout")
		print("Recovering...")
		recovery = true
		moveBoxes = false
		yield(get_tree().create_timer(0.1833333), "timeout")
		backSpeed = 2
		moveSpeed = 1
		canAttack = true
		print("Can attack now.")
	if Input.is_action_just_pressed("p" + str(playerNumber) + "A") and canAttack and attackDir == "Right":
		print("Right Attack!")
		canAttack = false
		moveSpeed = 0
		backSpeed = 0
		print("Startup...")
		position.x += 1
		forwardKickBox.hide()
		yield(get_tree().create_timer(0.1833333), "timeout")
		forwardKickBox.show()
		moveBoxes = true
		print("Hitboxes.")
		velocity.x += 20
		yield(get_tree().create_timer(0.008333), "timeout")
		forwardKickBox.hide()
		print("Recovering...")
		recovery = true
		moveBoxes = false
		velocity.x += 10
		yield(get_tree().create_timer(0.183333), "timeout")
		recovery = false
		velocity.x = 0
		backSpeed = 2
		moveSpeed = 1
		canAttack = true
		print("Can attack now.")
	if Input.is_action_just_pressed("p" + str(playerNumber) + "A") and canAttack and attackDir == "Down":
		print("Down Attack!")
		canAttack = false
		backSpeed = 0
		moveSpeed = 0
		sprite.animation = "lowkick"
		print("Startup...")
		lowKickBox.hide()
		yield(get_tree().create_timer(0.1), "timeout")
		lowKickBox.show()
		moveBoxes = true
		yield(get_tree().create_timer(0.05), "timeout")
		lowKickBox.hide()
		print("Recovering...")
		recovery = true
		moveBoxes = false
		yield(get_tree().create_timer(0.1), "timeout")
		velocity.x = 0
		recovery = false
		backSpeed = 2
		moveSpeed = 1
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


func _on_CollisionChecker_body_entered(body):
	pass # Replace with function body.
