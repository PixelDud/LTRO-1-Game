extends KinematicBody2D

var velocity = Vector2.ZERO

export var flipSprite = false
export var playerNumber = 0
export var health = 200
export var moveSpeed = 1
export var backSpeed = 2
var canAttack = true
var attackDir = "right"
var block = "not"
var recovery = false
var hitStun = 0
var enemy = null
var damageMult = 1
onready var hitSound = $hitsoundeffecttest
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
		damageMult = 1
		attackCheck()
	
		
	if hitStun >= 1:
		hitStun -=1
		damageMult = 0.7
		$Sprite.play("takehit")
			
		
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
	
	if Input.is_action_pressed("p" + str(playerNumber) + "Left") and canAttack == true:
		if (playerNumber == 2):
			$Sprite.play("walk")
		else:
			$Sprite.play("shuffle")
	elif Input.is_action_pressed("p" + str(playerNumber) + "Right") and canAttack == true:
		if (playerNumber == 2):
			$Sprite.play("shuffle")
		else:
			$Sprite.play("walk")
	
	else:
		if Input.is_action_pressed("p" + str(playerNumber) + "A") and attackDir == "Left":
			if (playerNumber == 2):
				$Sprite.play("punch")
			else:
				$Sprite.play("kick")
		if Input.is_action_pressed("p" + str(playerNumber) + "A") and attackDir == "Right":
			if (playerNumber == 2):
				$Sprite.play("kick")
			else:
				$Sprite.play("punch")
		
		if canAttack == true:
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
		if playerNumber == 2:
			velocity.x += -20
		else:
			velocity.x += 20
		attack("punch")
		yield(get_tree().create_timer(0.008333), "timeout")
		print("Recovering...")
		recovery = true
		if playerNumber == 2:
			velocity.x += -10
		else:
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
				
				if (abs(enemy.position.x - position.x) <= 48):
					print("Attacking Player " + str(enemy.playerNumber) + ".")
					if enemy.block == "Standing":
						enemy.health -= 4 * damageMult
						enemy.hitStun += 5
						enemy.position.x += 3
					else:
						hitSound.play()
						enemy.health -= 20 * damageMult
						enemy.hitStun += 30
						enemy.position.x += 9
			"punch":
				
				if (abs(enemy.position.x - position.x) <= 48):
					if enemy.block == "Standing":
						enemy.health -= 7 * damageMult
						enemy.hitStun += 6
						enemy.position.x += 3
					else:
						hitSound.play()
						enemy.health -= 25 * damageMult
						enemy.hitStun += 14
						enemy.position.x += 10
			"fireball":
				pass
	else:
		match type:
			"lowkick":
				
				if (abs(enemy.position.x - position.x) <= 48):
					print("Attacking Player " + str(enemy.playerNumber) + ".")
					if enemy.block == "Standing":
						enemy.health -= 4 * damageMult
						enemy.hitStun += 5
						enemy.position.x += -3
					else:
						hitSound.play()
						enemy.health -= 15 * damageMult
						enemy.hitStun += 30
						enemy.position.x += -9
			
			"punch":
				
				if (abs(enemy.position.x - position.x) <= 60):
					if enemy.block == "Standing":
						enemy.health -= 7 * damageMult
						enemy.hitStun += 6
						enemy.position.x += -3
					else:
						hitSound.play()
						enemy.health -= 20 * damageMult
						enemy.hitStun += 14
						enemy.position.x += -10
			"fireball":
				pass
