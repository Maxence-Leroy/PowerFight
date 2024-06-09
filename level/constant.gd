extends Node

const level_base_path = "res://level/Level"

var fight_place_group: String = "fight_place"
var objective_group: String = "objective"

var current_stage = 1

func go_to_next_level():
	current_stage += 1
	var error = get_tree().change_scene_to_file(level_base_path + str(current_stage) + ".tscn")
	if(error != OK):
		print("Impossible de changer de niveau : " + str(error))

func has_next_level():
	var next_level_path = level_base_path + str(current_stage + 1) + ".tscn"
	return ResourceLoader.exists(next_level_path)
