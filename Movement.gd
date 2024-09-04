extends CharacterBody2D

var _speed = 400  # speed in pixels/sec
@export var _sprite: Sprite2D = null

func _physics_process(delta):
	var _direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	self.velocity = _direction * _speed
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		look_at(get_global_mouse_position())
	else: 
		look_at(self.global_position + _direction * 1000)
	move_and_slide()
