extends Area2D

class_name Character

var power: int = 0

func get_width():
	return ($CollisionShape2D.shape as RectangleShape2D).extents.x * 2

func set_power(value: int):
	power = value
	$Label.text = str(value)
