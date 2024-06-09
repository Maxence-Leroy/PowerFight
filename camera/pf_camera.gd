extends Camera2D

class_name PFCamera

const speed = 500
const zoom_min = 0.6
var zoom_max = 4

func _ready():
	position_smoothing_enabled = false

func set_limits(i_limit_top: int, i_limit_bottom: int, i_limit_left: int, i_limit_right: int):
	limit_top = i_limit_top
	limit_bottom = i_limit_bottom
	limit_left = i_limit_left
	limit_right = i_limit_right
	clamp_position_and_zoom()

func _input(event):
	if event is InputEventMagnifyGesture:
		zoom.x /= event.factor
		zoom.y /= event.factor
		clamp_position_and_zoom()
	if event is InputEventPanGesture:
		position -= event.delta * 100
		clamp_position_and_zoom()

func _process(delta):
	if Input.is_action_pressed("camera_down"):
		position.y += speed * delta
		clamp_position_and_zoom()
	if Input.is_action_pressed("camera_up"):
		position.y -= speed * delta
		clamp_position_and_zoom()
	if Input.is_action_pressed("camera_left"):
		position.x -= speed * delta
		clamp_position_and_zoom()
	if Input.is_action_pressed("camera_right"):
		position.x += speed * delta
		clamp_position_and_zoom()

func clamp_position_and_zoom():
	var viewport_size = get_viewport().size
	
	zoom_max = (limit_right - limit_left) / viewport_size.x 
	
	var zoom_x = clamp(zoom.x, zoom_min, zoom_max)
	var zoom_y = clamp(zoom.y, zoom_min, zoom_max)
	zoom = Vector2(zoom_x, zoom_y)
	
	var min_x = limit_left + zoom.x * viewport_size.x / 2
	var max_x = limit_right - zoom.x * viewport_size.x / 2
	var min_y = limit_top + zoom.y * viewport_size.y / 2
	var max_y = limit_bottom - zoom.y * viewport_size.y / 2
	
	var camera_x = clamp(position.x, min_x, max_x)
	var camera_y = clamp(position.y, min_y, max_y)
	
	position.x = camera_x
	position.y = camera_y
