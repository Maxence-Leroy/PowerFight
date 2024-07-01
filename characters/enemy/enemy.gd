extends Character

class_name Enemy

@onready var animation = $AnimatedSprite2D

var rng = RandomNumberGenerator.new()
var type = ""

func _ready():
	var type_id = rng.randi_range(1, 1)
	if type_id == 1:
		type="orc"
	var time_to_wait_ms = rng.randi_range(0, 1000) / 1000.0
	await get_tree().create_timer(time_to_wait_ms).timeout
	animation.play(type + "_idle")
