extends CharacterBody2D
var laser_scene = preload("res://Scenes/laser.tscn")  # Path to your enemy scene

var SPEED = 400  # Adjust this to control how fast the player moves
var counter = 0

func _ready() -> void:
	position = Vector2(0,0)

func _physics_process(delta: float) -> void:
	
	#var direction = Input.get_vector("left", "right", "up", "down")
	#velocity=direction*SPEED;
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED)
	var mouse_pos =  get_viewport().get_mouse_position()
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if counter%200 == 0:
		counter =0
	velocity = (mouse_pos - position) * SPEED * delta
	print(counter)
	if counter%10==0:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var laser = laser_scene.instantiate()
			laser.position = global_position
			get_parent().add_child(laser)  # Add this line to add the laser to the scene
			
	move_and_slide()
	counter+=1
