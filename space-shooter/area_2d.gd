extends Area2D

var speed = 1000
var window_height = DisplayServer.window_get_size().y

# Called when the node is first added to the scene
func _ready():
	area_entered.connect(_on_area_entered)

# Called every physics frame (1/60th of a second by default)
func _physics_process(delta):
	position.y -= speed * delta
	
	# Remove the laser if it goes too far up
	if position.y < -window_height:
		queue_free()  # Deletes the laser node

# This function runs whenever another Area2D touches our laser
func _on_area_entered(area):
	# Check if what we hit is an enemy
	if area.get_parent().is_in_group("enemies"):
		area.get_parent().take_damage()  # Call take_damage on the enemy
		queue_free()       # Remove the laser
