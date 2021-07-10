extends KinematicBody2D



var moveSpeed = 120
var health = 100
var velocity = Vector2.ZERO

onready var healthBar = get_parent().get_node("healthBar")
func _ready():
	pass
	
#heres where i will put movement shit plus inputs

func get_input():
	
	velocity.x = 0
	if Input.is_action_pressed("p1Left"):
		velocity.x -= moveSpeed
	if Input.is_action_pressed("p1Right"):
		velocity.x += moveSpeed/0.7
	if Input.is_action_pressed("p1Down"):
		pass
	if Input.is_action_pressed("p1Up"):
		pass
	if Input.is_action_just_pressed("ui_focus_next"):
		health -= 10
		
		velocity = velocity.normalized() * moveSpeed
		
func _process(delta):
	healthBar.value = health
	get_input()
	velocity = move_and_slide(velocity,Vector2.UP)
