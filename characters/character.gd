extends Area2D

class_name Character

var power: int = 0

func get_width():
	return ($CollisionShape2D.shape as RectangleShape2D).extents.x * 2

func set_is_objective():
	$ObjectiveLabel.visible = true
	add_to_group(Constants.objective_group)

func set_power(value: int):
	power = value
	$PowerLabel.text = str(value)
	if value == 0:
		$PowerLabel.hide()
