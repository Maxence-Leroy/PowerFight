extends Area2D

class_name FightPlace

func _ready():
	add_to_group(Constants.fight_place_group)

func add_player(player: Player):
	_move_player(player)

func _move_player(player: Player):
	var player_position = Vector2()
	player_position.y = position.y
	var width = ($CollisionShape2D.shape as RectangleShape2D).extents.x
	player_position.x = position.x - width / 2 + 5
	player.position = player_position
