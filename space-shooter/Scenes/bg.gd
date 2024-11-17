extends Node2D

# Preload the enemy scene
var enemy_scene = preload("res://Scenes/enemy.tscn")

# Wave-related variables
var current_wave = 1
var enemies_per_wave = 5  # Start with 5 enemies per wave
var wave_delay = 5.0  # Delay between waves in seconds
var spawn_timer = 0.0  # Internal timer to track time between enemy spawns

# Gameplay variables
var total_enemies_spawned = 0
var enemies_remaining = 0

# Spawn pattern variables
var spawn_patterns = [
	{
		"type": "line",
		"x_positions": [100, 200, 300, 400, 500]
	},
	{
		"type": "triangle",
		"x_positions": [200, 300, 400]
	},
	{
		"type": "circle",
		"radius": 200,
		"center": Vector2(300, 100)
	}
]
var current_spawn_pattern_index = 0

func _ready():
	# Start the first wave
	start_new_wave()

func _process(delta):
	if enemies_remaining > 0:
		# Spawn enemies at regular intervals
		spawn_timer += delta
		if spawn_timer >= 1.0 / (enemies_per_wave / wave_delay):
			spawn_timer = 0.0
			spawn_enemy()
			enemies_remaining -= 1
	elif total_enemies_spawned < current_wave * enemies_per_wave:
		# Wait for the wave delay before starting the next wave
		spawn_timer += delta
		if spawn_timer >= wave_delay:
			start_new_wave()

func start_new_wave():
	print("Starting Wave ", current_wave)
	enemies_remaining = enemies_per_wave
	spawn_timer = 0.0

	# Increase the difficulty for the next wave
	enemies_per_wave += 2
	wave_delay *= 0.9  # Reduce the wave delay

	# Select the next spawn pattern
	current_spawn_pattern_index = (current_spawn_pattern_index + 1) % len(spawn_patterns)

	current_wave += 1
	total_enemies_spawned += enemies_per_wave

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	var spawn_pattern = spawn_patterns[current_spawn_pattern_index]
	if spawn_pattern["type"] == "line":
		enemy.position = Vector2(
			spawn_pattern["x_positions"][total_enemies_spawned % len(spawn_pattern["x_positions"])],
			100
		)
	elif spawn_pattern["type"] == "triangle":
		enemy.position = Vector2(
			spawn_pattern["x_positions"][total_enemies_spawned % len(spawn_pattern["x_positions"])],
			100
		)
	elif spawn_pattern["type"] == "circle":
		var angle = 2 * PI * (total_enemies_spawned % len(spawn_pattern["x_positions"])) / len(spawn_pattern["x_positions"])
		enemy.position = spawn_pattern["center"] + Vector2(spawn_pattern["radius"] * cos(angle), spawn_pattern["radius"] * sin(angle))

	enemy.connect("damaged", self, "_on_enemy_damaged")
	add_child(enemy)

func _on_enemy_damaged(enemy):
	enemy.take_damage()
