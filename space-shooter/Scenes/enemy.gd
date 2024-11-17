extends CharacterBody2D

var speed = 200
var health = 10
var move_direction = Vector2(1, 0)  # Move horizontally by default

onready var animation_player = $AnimationPlayer

func _ready():
	# Add the enemy to the "enemies" group so lasers can detect it
	add_to_group("enemies")

func _physics_process(delta):
	# Basic side-to-side movement
	position += move_direction * speed * delta

	# Change direction when reaching screen edges
	if position.x > get_viewport_rect().size.x - 50:  # Right edge
		move_direction.x = -1
	elif position.x < 50:  # Left edge
		move_direction.x = 1

	# Move the enemy downwards
	position.y += 200 * delta

	# Check if the enemy has gone off-screen
	if position.y > get_viewport_rect().size.y + 50:
		queue_free()  # Destroy the enemy if it goes off-screen

func take_damage():
	health -= 1
	if health <= 0:
		# Optional: Add explosion effect or score here
		queue_free()  # Remove the enemy when destroyed
	else:
		# Play the "Damaged" animation
		animation_player.play("Damaged")
