extends Node2D

class_name BaseLevel

enum LevelObjective {KILL_EVERYONE, GET_OBJECTIVES}
export(LevelObjective) var objective
export(int) var level_id

var player: Player = null
var moves = 0
onready var game_over_container: CenterContainer = $CanvasLayer/GameOverContainer
onready var success_container: CenterContainer = $CanvasLayer/SuccessContainer
onready var success_button: Button = $CanvasLayer/SuccessContainer/PanelContainer/VBoxContainer/ContinueButton
onready var success_label: Label = $CanvasLayer/SuccessContainer/PanelContainer/VBoxContainer/Label
onready var rooms: Node2D = $Rooms
onready var camera: PFCamera = $PFCamera

func _ready():
	game_over_container.hide()
	success_container.hide()
	_place_rooms()
	player = find_node("Player", true, false)
	if player != null:
		var error = player.connect("moved_to_place", self, "_on_player_moved_to_new_place")
		if error != OK:
			print("Impossible de connecter le signal moved_to_place : " + str(error))
		error = player.connect("player_died", self, "_on_player_died")
		if error != OK:
			print("Impossible de connecter le signal player_died : " + str(error))
	
	for room in rooms.get_children():
		if room is FightPlace:
			room.connect("place_cleared", self, "_on_fight_place_cleared")

func _place_rooms():
	var list_of_rooms = rooms.get_children()
	var room_width = (list_of_rooms[0] as FightPlace).get_width()
	var room_height = (list_of_rooms[0] as FightPlace).get_height()
	var screen_size = get_viewport_rect().size
	var number_of_columns = 2
	var space_between_columns = (screen_size.x - number_of_columns * room_width) / (number_of_columns - 1)
	var space_between_lines = 20
	var max_line = 0
	var max_column = 0
	for room in list_of_rooms:
		var typed_room = room as FightPlace
		var room_name: String = typed_room.name
		var splitted_name = room_name.split("-")
		var id_column = int(splitted_name[0])
		var id_line = int(splitted_name[1])
		max_column = max(id_column, max_column)
		max_line = max(id_line, max_line)
		typed_room.position = Vector2(
			room_width / 2 + id_column * (room_width + space_between_columns),
			room_height / 2 +id_line * (room_height + space_between_lines)
		)
	var limit_top = 0
	var limit_bottom = (max_line + 1) * room_height + max_line * space_between_lines
	var limit_left = 0
	var limit_right = (max_column + 1) * room_width + max_column * space_between_columns
	camera.set_limits(limit_top, limit_bottom, limit_left, limit_right)

func _all_objectives_collected():
	var objectives = get_tree().get_nodes_in_group(Constants.objective_group)
	return objectives.empty()
	
func _on_player_moved_to_new_place(new_place: Area2D):
	var place = new_place as FightPlace
	if place == null:
		return
	moves += 1
	place.add_player(player)

func _on_player_died():
	game_over_container.show()

func _on_fight_place_cleared():
	if objective == LevelObjective.KILL_EVERYONE:
		var ennemy = find_node("Ennemy", true, false)
		if ennemy == null:
			_on_success()
	elif objective == LevelObjective.GET_OBJECTIVES:
		if _all_objectives_collected():
			_on_success()

func _on_success():
	success_label.text = "C'est gagné en " + str(moves) + " coups !"
	_save(level_id, moves)
	if Constants.has_next_level():
		success_button.text = "Continue"
	else:
		success_button.text = "Fin du jeu"
	success_container.show()

func _save(id: int, nb_moves: int):
	var str_id = str(id)
	var path = "user://savegame.save"
	var save_game = File.new()
	save_game.open(path, File.READ)
	var dict = {}
	if save_game.get_len() > 0:
		dict = parse_json(save_game.get_line())
	save_game.close()
	save_game.open(path, File.WRITE)
	if dict.has(str_id):
		if nb_moves < dict[str_id]:
			dict[str_id] = nb_moves
	else:
		dict[str_id] = nb_moves
	save_game.store_line(to_json(dict))
	save_game.close()

func _on_restart_pressed():
	var error = get_tree().reload_current_scene()
	if error != OK:
		print("Impossible de recharger le niveau : " + str(error))

func _on_next_pressed():
	if Constants.has_next_level():
		Constants.go_to_next_level()
