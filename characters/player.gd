extends Character

class_name Player

var can_grab = false
var grabbed_offset = Vector2()
var colliding_places = []
var initial_position = Vector2()

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			can_grab = true
			initial_position = position
			grabbed_offset = position - get_global_mouse_position()
		else:
			can_grab = false
			move_to_right_place()

func _process(_delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position = get_global_mouse_position() + grabbed_offset

func _on_colliding_start(area: Area2D):
	if area.is_in_group(Constants.fight_place_group):
		colliding_places.append(area)


func _on_colling_finish(area):
	if area.is_in_group(Constants.fight_place_group):
		var place_index = colliding_places.find(area)
		if place_index != -1:
			colliding_places.remove(place_index)

func move_to_right_place():
	if colliding_places.empty():
		position = initial_position
		return
	else:
		var min_distance = -1
		var min_index = -1
		var index = 0
		for place in colliding_places:
			if place is Area2D:
				var distance = position.distance_squared_to(place.position)
				if distance < min_distance or min_distance == -1:
					min_distance = distance
					min_index = index
			index += 1
		Constants.move_player_to_place(self, colliding_places[min_index])
