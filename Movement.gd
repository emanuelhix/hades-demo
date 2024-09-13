extends CharacterBody2D

# Speed of the character in pixels per second
var _speed = 400

# Exported variables to configure the Sprite and Gun from the Godot editor
@export var _sprite: Sprite2D = null  # Reference to the Sprite2D node
@export var gun: Gun = null           # Reference to the Gun node

func _ready() -> void:
	# Called when the node is added to the scene.
	pass

func _physics_process(delta: float) -> void:
	# Process physics-related updates every frame

	# Get the direction of movement based on input
	var _direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Update the velocity based on direction and speed
	self.velocity = _direction * _speed
	
	# Handle aiming and rotation
	if Input.is_action_pressed("aim"):
		# Get the aiming direction from input
		var aim_vec := Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		
		# Smoothly rotate the character towards the aim direction
		rotation = lerp_angle(rotation, aim_vec.angle(), 0.2)
	else:
		# If not aiming, make the character face in the direction of movement
		look_at(self.global_position + _direction * 1000)
	
	# Move the character and handle collisions
	move_and_slide()

func _process(delta: float) -> void:
	# Process general updates every frame
	
	# If the aim action is pressed, trigger the gun to fire
	if Input.is_action_pressed("aim"):
		gun.fire()
