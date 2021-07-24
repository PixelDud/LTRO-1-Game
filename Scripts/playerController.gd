extends KinematicBody2D

var velocity = Vector2.ZERO

export var playerNumber = 0
export var health = 200
export var moveSpeed = 1
export var backSpeed = 2
var inputTimeout = 0.5
var canAttack = true
var block = false
var hitType = "nothing"
var recovery = false
var hitStun = 0
var enemy = null
var damageMult = 1
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
	
	in_bounds()
	animation_handler()
	if hitStun == 0:
		movement_input()
#		dash_input()
		attackCheck()
	if hitStun >= 1:
		damageMult = 0.7
		hitStun -= 1
		$Sprite.animation = "takehit"
	else:
		damageMult = 1
	healthBar.value = health
	
	if (healthBar.value <= 0):
		print("I'm dead!")
	
	if Input.is_action_just_pressed("ui_focus_next"):
		health -= 5
		hitStun += 10
	
	velocity = move_and_slide(velocity, Vector2.DOWN)

func in_bounds():
	if playerNumber == 1:
		if (position.x < 16):
			position.x = 16
	else:
		if (position.x > 224):
			position.x = 224
		

func movement_input():
	if Input.is_action_pressed("p" + str(playerNumber) + "Up"):
		pass
	elif Input.is_action_pressed("p" + str(playerNumber) + "Down"):
		if playerNumber == 2:
			block = true
		if playerNumber == 1:
			block = true
		if canAttack:
			$Sprite.play("p" + str(playerNumber) + "Block")
	elif Input.is_action_pressed("p" + str(playerNumber) + "Left"):
		if (playerNumber == 2):
			position.x -= moveSpeed 
			block = false
		else:
			position.x -= backSpeed * 0.3
			block = true
	elif Input.is_action_pressed("p" + str(playerNumber) + "Right"):
		if (playerNumber == 1):
			position.x += moveSpeed
			block = false
		else:
			position.x += backSpeed * 0.3
			block = true
	else:
		block = false

func animation_handler():
	if Input.is_action_pressed("p" + str(playerNumber) + "Left"):
		if (playerNumber == 2):
			$Sprite.play("p" + str(playerNumber) + "Walk")
		else:
			$Sprite.play("p" + str(playerNumber) + "Shuffle")
	elif Input.is_action_pressed("p" + str(playerNumber) + "Right"):
		if (playerNumber == 2):
			$Sprite.play("p" + str(playerNumber) + "Shuffle")
		else:
			$Sprite.play("p" + str(playerNumber) + "Walk")
	else:
		if Input.is_action_pressed("p" + str(playerNumber) + "A"):
			$Sprite.play("p" + str(playerNumber) + "Punch")
		if Input.is_action_pressed("p" + str(playerNumber) + "B"):
			$Sprite.play("p" + str(playerNumber) + "Kick")
		if canAttack == true:
			$Sprite.play("p" + str(playerNumber) + "Idle")

func attackCheck():
	if Input.is_action_just_pressed("p" + str(playerNumber) + "A") and canAttack:
		$Attack.play()
		print("Right Attack!")
		canAttack = false
		moveSpeed = 0
		backSpeed = 0
		print("Startup...")
		position.x += 1
		yield(get_tree().create_timer(0.1833333), "timeout")
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
	if Input.is_action_just_pressed("p" + str(playerNumber) + "B") and canAttack:
		$Attack.play()
		print("Left Attack!")
		canAttack = false
		backSpeed = 0
		moveSpeed = 0
		print("Startup...")
		yield(get_tree().create_timer(0.1), "timeout")
		attack("kick")
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
			"kick":
				if (abs(enemy.position.x - position.x) <= 48):
					print("Attacking Player " + str(enemy.playerNumber) + ".")
					if enemy.block == true:
						$BlockHit.play()
						enemy.get_node("Sprite").play("p" + str(playerNumber) + "BlockHit")
						enemy.health -= 4 * damageMult
						enemy.hitStun += 5
						enemy.position.x += 3
					else:
						$Hit.play()
						enemy.get_node("Sprite").play("p" + str(playerNumber) + "Hit")

						enemy.health -= 15 * damageMult
						enemy.hitStun += 26
						enemy.position.x += 9

						enemy.health -= 20 * damageMult
						enemy.hitStun += 20
						enemy.position.x += 13

			"punch":
				if (abs(enemy.position.x - position.x) <= 48):
					if enemy.block == true:
						$BlockHit.play()
						enemy.get_node("Sprite").play("p" + str(playerNumber) + "BlockHit")
						enemy.health -= 7 * damageMult
						enemy.hitStun += 6
						enemy.position.x += 3
					else:
						$Hit.play()
						enemy.get_node("Sprite").play("p" + str(playerNumber) + "Hit")
						enemy.health -= 25 * damageMult
						enemy.hitStun += 14
						enemy.position.x += 10
	else:
		match type:
			"kick":
				if (abs(enemy.position.x - position.x) <= 48):
					print("Attacking Player " + str(enemy.playerNumber) + ".")
					if enemy.block == true:
						$BlockHit.play()
						enemy.get_node("Sprite").play("p" + str(playerNumber) + "BlockHit")
						enemy.health -= 4 * damageMult
						enemy.hitStun += 5
						enemy.position.x -= 3
					else:
						$Hit.play()
						enemy.get_node("Sprite").play("p" + str(playerNumber) + "Hit")
						enemy.health -= 15 * damageMult
						enemy.hitStun += 20
						enemy.position.x -= 13

			"punch":
				if (abs(enemy.position.x - position.x) <= 48):
					if enemy.block == true:
						$BlockHit.play()
						enemy.get_node("Sprite").play("p" + str(playerNumber) + "BlockHit")
						enemy.health -= 7 * damageMult
						enemy.hitStun += 6
						enemy.position.x -= 3
					else:
						$Hit.play()
						enemy.get_node("Sprite").play("p" + str(playerNumber) + "Hit")
						enemy.health -= 25 * damageMult
						enemy.hitStun += 14
						enemy.position.x -= 10
