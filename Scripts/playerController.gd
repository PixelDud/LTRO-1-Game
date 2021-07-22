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
var canAttack = true
var attackDir = "right"
var block = "not"
var hitType = "nothing"
var recovery = false
var hitStun = 0
var enemy = null
#hitType is for deciding whether a move hits low, medium, or high
#recovery is when you are recovering from doing a move

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
	
	if playerNumber == 1:
		enemy = get_tree().get_root().get_node("World/Viewport/Player2")
	else:
		enemy = get_tree().get_root().get_node("World/Viewport/Player")
	
	$Sprite.flip_h = flipSprite
	
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
	block = "not"
	

	if Input.is_action_pressed("p" + str(playerNumber) + "Left"):
#		print("Left!")
		
		if (playerNumber == 2):
			position.x -= moveSpeed 
			block = "not"
			attackDir = "Left"
		else:
			position.x -= backSpeed * 0.3
			block = "Standing"
			attackDir = "Left"
	elif Input.is_action_pressed("p" + str(playerNumber) + "Right"):
#		print("Right!")
		
		if (playerNumber == 1):
			position.x += moveSpeed
			block = "not"
			attackDir = "Right"
		else:
			position.x += backSpeed * 0.3
			block = "Standing"
			attackDir = "Right"
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


#stats
#damage: down a = 20, forward a = 25, back a = 15 + 15, up a = 40

func attackCheck():
	
	if Input.is_action_just_pressed("p" + str(playerNumber) + "A") and canAttack and attackDir == "Right":
		print("Right Attack!")
		canAttack = false
		moveSpeed = 0
		backSpeed = 0
		print("Startup...")
		position.x += 1
		yield(get_tree().create_timer(0.1833333), "timeout")
		print("Hitboxes.")
		velocity.x += 20
		attack("punch")
		yield(get_tree().create_timer(0.008333), "timeout")
		print("Recovering...")
		recovery = true
		velocity.x += 10
		yield(get_tree().create_timer(0.183333), "timeout")
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
		yield(get_tree().create_timer(0.1), "timeout")
		attack("lowkick")
		yield(get_tree().create_timer(0.05), "timeout")
		print("Recovering...")
		recovery = true
		yield(get_tree().create_timer(0.1), "timeout")
		velocity.x = 0
		recovery = false
		backSpeed = 2
		moveSpeed = 1
		canAttack = true
		print("Can attack now.")
	
func attack(type):
	if playerNumber == 1:
		match type:
			"lowkick":
				block = "Standing"
				if (abs(enemy.position.x - position.x) <= 48):
					print("Attacking Player " + str(enemy.playerNumber) + ".")
					if block == "Standing":
						enemy.health -= 4
						enemy.hitStun += 11
					else:
						enemy.health -= 20
						enemy.hitStun += 13
			
			"punch":
				block = "Standing"
				if (abs(enemy.position.x - position.x) <= 48):
					if block == "Standing":
						enemy.health -= 7
						enemy.hitStun += 6
					else:
						enemy.health -= 25
						enemy.hitStun += 14
	else:
		match type:
			"lowkick":
				block = "Standing"
				if (abs(enemy.position.x - position.x) <= 48):
					print("Attacking Player " + str(enemy.playerNumber) + ".")
					if block == "Standing":
						enemy.health -= 4
						enemy.hitStun += 11
					else:
						enemy.health -= 20
						enemy.hitStun += 13
			
			"punch":
				block = "Standing"
				if (abs(enemy.position.x - position.x) <= 100):
					if block == "Standing":
						enemy.health -= 7
						enemy.hitStun += 6
					else:
						enemy.health -= 25
						enemy.hitStun += 14
