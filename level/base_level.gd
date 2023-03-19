extends Node2D

class_name BaseLevel

enum LevelObjective {KILL_EVERYONE, GET_OBJECTIVES}
export(LevelObjective) var objective

var player: Player = null
onready var game_over_container: CenterContainer = $CanvasLayer/GameOverContainer
onready var success_container: CenterContainer = $CanvasLayer/SuccessContainer
onready var success_button: Button = $CanvasLayer/SuccessContainer/PanelContainer/VBoxContainer/ContinueButton

func _ready():
	game_over_container.hide()
	success_container.hide()
	player = find_node("Player", true, false)
	if player != null:
		var error = player.connect("moved_to_place", self, "_on_player_moved_to_new_place")
		if error != OK:
			print("Impossible de connecter le signal moved_to_place : " + str(error))
		error = player.connect("player_died", self, "_on_player_died")
		if error != OK:
			print("Impossible de connecter le signal player_died : " + str(error))
	
	var children = get_children()
	for child in children:
		if child is FightPlace:
			child.connect("place_cleared", self, "_on_fight_place_cleared")

func _all_objectives_collected():
	var objectives = get_tree().get_nodes_in_group(Constants.objective_group)
	return objectives.empty()
	
func _on_player_moved_to_new_place(new_place: Area2D):
	var place = new_place as FightPlace
	if place == null:
		return
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
	if Constants.has_next_level():
		success_button.text = "Continue"
	else:
		success_button.text = "Fin du jeu"
	success_container.show()

func _on_restart_pressed():
	var error = get_tree().reload_current_scene()
	if error != OK:
		print("Impossible de recharger le niveau : " + str(error))

func _on_next_pressed():
	if Constants.has_next_level():
		Constants.go_to_next_level()
