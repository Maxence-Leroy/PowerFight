extends Camera2D

class_name PFCamera

const speed = 500

func _ready():
	smoothing_enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("camera_down"):
		position.y += speed * delta
	if Input.is_action_pressed("camera_up"):
		position.y -= speed * delta
	if Input.is_action_pressed("camera_left"):
		position.x -= speed * delta
	if Input.is_action_pressed("camera_right"):
		position.x += speed * delta
