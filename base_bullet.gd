extends CharacterBody2D

var speed = 15
var direction = Vector2.RIGHT

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(self.global_rotation)

func _process(delta: float) -> void:
	velocity = direction * speed
	rotation += delta * 100
	var collided = move_and_collide(velocity)
	if collided:
		queue_free()
