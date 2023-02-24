extends Node2D

class_name BaseLevel

var player: Player = null

func _ready():
	player = find_node("Player", true, false)
	if player != null:
		player.connect("moved_to_place", self, "_on_player_moved_to_new_place")
	
func _on_player_moved_to_new_place(new_place: Area2D):
	var place = new_place as FightPlace
	if place == null:
		return
	place.add_player(player)

