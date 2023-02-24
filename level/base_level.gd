extends Node2D

class_name BaseLevel

enum LevelObjective {KILL_EVERYONE}
export(LevelObjective) var objective

var player: Player = null
onready var game_over_container: CenterContainer = $CanvasLayer/GameOverContainer
onready var success_container: CenterContainer = $CanvasLayer/SuccessContainer

func _ready():
	game_over_container.hide()
	success_container.hide()
	player = find_node("Player", true, false)
	if player != null:
		player.connect("moved_to_place", self, "_on_player_moved_to_new_place")
		player.connect("player_died", self, "_on_player_died")
	
	var children = get_children()
	for child in children:
		if child is FightPlace:
			child.connect("place_cleared", self, "_on_fight_place_cleared")
	
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

func _on_success():
	success_container.show()

func _on_restart_pressed():
	get_tree().reload_current_scene()
