extends Node2D

class_name BaseLevel

var player: Player = null
onready var game_over_container: CenterContainer = $CanvasLayer/GameOverContainer

func _ready():
	game_over_container.hide()
	player = find_node("Player", true, false)
	if player != null:
		player.connect("moved_to_place", self, "_on_player_moved_to_new_place")
		player.connect("player_died", self, "_on_player_died")
	
func _on_player_moved_to_new_place(new_place: Area2D):
	var place = new_place as FightPlace
	if place == null:
		return
	place.add_player(player)

func _on_player_died():
	game_over_container.show()


func _on_restart_pressed():
	get_tree().reload_current_scene()
