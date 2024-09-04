extends Node2D

@export var character: CharacterBody2D = null
var _sight_line: Line2D = null;
var _sight_line_2: Line2D = null;
var _sight_line_3: Line2D = null;
var _spread_angle: float = 180;
var _max_distance: float = 400;

var _total_delta: float = 0
var _end_position = Vector2.ZERO;
var _end_position_2 = Vector2.ZERO;
var _end_position_3 = Vector2.ZERO;


func orthogonal_clockwise(sight, origin, distance):
	var v = Vector2(-sight.y, sight.x)
	v = v.normalized() * distance
	v = v + origin
	return v

func _on_timer_timeout():
	_sight_line_3.clear_points()  
	# get point on plane spanned by the two end positio ns (they are orthogonal to eachother)
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		return
## FIXME: the 1 constants need to be something that i can scale along the two orthogonal axises
	_end_position_3 = _end_position * 1 + _end_position_2 * 1
	_sight_line_3.add_point(character.global_position)
	_sight_line_3.add_point(_end_position_3)

func _ready():
	_sight_line = Line2D.new()
	_sight_line_2 = Line2D.new()
	_sight_line_2.default_color = Color(Color.RED)
	_sight_line_2.width = 5
	_sight_line_3 = Line2D.new()
	_sight_line_3.default_color = Color(Color.SKY_BLUE)
	_sight_line_3.width = 1
	add_child(_sight_line)
	add_child(_sight_line_2)
	add_child(_sight_line_3)
	var reset_timer = Timer.new()    
	add_child(reset_timer)
	reset_timer.wait_time = 0.1
	reset_timer.one_shot = false  
	reset_timer.timeout.connect(_on_timer_timeout)
	reset_timer.start()

func _process(delta):
	_total_delta += delta
	_sight_line.clear_points()
	_sight_line_2.clear_points()
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		return
	var _direct_sight = (get_global_mouse_position() - character.global_position).normalized() * _max_distance
	_end_position = get_global_mouse_position()
	_end_position_2 = orthogonal_clockwise(_direct_sight, character.global_position, get_global_mouse_position().distance_to(character.global_position))
	if character.global_position.distance_to(_end_position) > _max_distance:
		_end_position = character.global_position + _direct_sight
		_end_position_2 = orthogonal_clockwise(_direct_sight, character.global_position, _max_distance)
	_sight_line.add_point(character.global_position)
	_sight_line_2.add_point(character.global_position)
	_sight_line_2.add_point(_end_position_2)
	_sight_line.add_point(_end_position)
