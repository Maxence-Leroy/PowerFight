extends Node

var fight_place_group: String = "fight_place"

func move_player_to_place(player: Player, area: Area2D):
	var place = area as FightPlace
	if place == null:
		return
	place.add_player(player)
