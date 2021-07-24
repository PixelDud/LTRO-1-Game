extends Node2D

onready var player2hp = $Viewport/Player2
onready var player1hp = $Viewport/Player
onready var pleaseplay = $pleaseplay
export var rounds = 6
export var p1wins = 0
export var p2wins = 0
export var roundTimer = 25

func newround():
	player1hp.health = 200
	player2hp.health = 200
	player1hp.position.x = 32
	player2hp.position.x = 208
	pleaseplay.play()
	yield(get_tree().create_timer(roundTimer), "timeout")
	checkwinner()
	
func checkwinner():
	if player1hp.health > player2hp.health:
		p1wins +=1
		newround()
	if player2hp.health > player1hp.health:
		p2wins +=1
		newround()
func _ready():
	newround()
		
func _process(delta):
	
	
	if player1hp.health <= 0:
		p2wins += 1
		newround()
	elif player2hp.health <= 0:
		p1wins += 1
		newround()
	if p2wins >= rounds: 
		print("p2wins")
		get_tree().quit()
	elif p1wins >= rounds:
		get_tree().quit()
		print("p1wins")
