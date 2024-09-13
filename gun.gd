extends Node2D

class_name Gun

# Exported variables allow you to configure these properties from the Godot editor
@export var projectile: PackedScene  # Scene resource for the projectile
@export var bullet_count: int = 1     # Number of bullets fired at once
@export_range(0, 360) var spread: float = 0  # Spread angle in degrees
@export_range(0, 20) var rate: float = 15    # Fire rate (bullets per second)

var enabled: bool = true  # Flag to enable/disable firing (debounce)

func _process(delta: float) -> void:
	# Handle input for adjusting bullet count
	if Input.is_action_just_pressed("increase_count"):
		print(bullet_count)
		bullet_count += 1
	elif Input.is_action_just_pressed("decrease_count"):
		print(bullet_count)
		bullet_count -= 1
	
	# Handle input for adjusting spread
	if Input.is_action_pressed("increase_spread"):
		print(spread)
		spread += 1
	elif Input.is_action_pressed("decrease_spread"):
		print(spread)
		spread -= 1

func _ready() -> void:
	# Convert spread angle to radians for use in calculations
	spread = deg_to_rad(spread)
	# Instantiate projectile to prepare it for firing
	projectile.instantiate()

func fire() -> void:
	# Prevent firing if the gun is not enabled
	if not enabled: 
		return
	
	enabled = false  # Disable firing while processing

	# Fire multiple bullets based on bullet_count
	for i in range(bullet_count): 
		var p := projectile.instantiate()  # Instantiate a new projectile
		p.position = global_position  # Set the projectile position to the gun's position
		
		if bullet_count == 1:
			p.rotation = global_rotation  # Set rotation if only one bullet is fired
		else:
			# Calculate and set the projectile's rotation based on spread and bullet index
			var inc = spread / (bullet_count - 1)
			p.global_rotation = global_rotation + inc * i - spread / 2
		
		# Add the projectile to the scene tree
		get_tree().root.call_deferred("add_child", p)
		
		# Wait for the duration of the rate before re-enabling firing
		await get_tree().create_timer(1 / rate).timeout
		enabled = true
