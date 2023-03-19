extends Node

var fight_place_group: String = "fight_place"
var objective_group: String = "objective"

var current_stage = 1

func go_to_next_level():
	current_stage += 1
	var error = get_tree().change_scene("res://level/Level" + str(current_stage) + ".tscn")
	if(error != OK):
		print("Impossible de changer de niveau : " + str(error))
