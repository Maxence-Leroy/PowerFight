extends Area2D

class_name FightPlace

enum CharacterType {PLAYER, ENNEMY}
export(Array, int) var character_power
export(Array, CharacterType) var character_type

const EnnemyResource = preload("res://characters/ennemy.tscn")
const PlayerResource = preload("res://characters/player.tscn")

func get_width():
	return ($CollisionShape2D.shape as RectangleShape2D).extents.x * 2

func _ready():
	add_to_group(Constants.fight_place_group)
	
	assert(character_power.size() == character_type.size(), "Arrays' size must be the same")
	
	var number_of_characters = character_power.size()
	for i in range(0, number_of_characters, 1):
		var character: Character
		
		if character_type[i] == CharacterType.ENNEMY:
			character = EnnemyResource.instance()
			var ennemy_position = Vector2()
			ennemy_position.x = get_width() / 2 - character.get_width() / 2 - 5 - 105*i
			character.position = ennemy_position
		if character_type[i] == CharacterType.PLAYER:
			character = PlayerResource.instance()
			var player_position = Vector2()
			player_position.x = -get_width() / 2 + character.get_width() / 2 + 5
			character.position = player_position
		character.power = character_power[i]
		add_child(character)

func add_player(player: Player):
	_move_player(player)

func _move_player(player: Player):
	player.get_parent().remove_child(player)
	add_child(player)
	var player_position = Vector2()
	player_position.x =  -get_width() / 2 + player.get_width() / 2 + 5
	player.position = player_position
