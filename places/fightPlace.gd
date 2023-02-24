extends Area2D

class_name FightPlace

signal place_cleared

enum CharacterType {PLAYER, ENNEMY, ADDITIVE_TREASURE }
export(Array, int) var character_power
export(Array, CharacterType) var character_type

const EnnemyResource = preload("res://characters/ennemy.tscn")
const PlayerResource = preload("res://characters/player.tscn")
const AdditiveTreasureResource = preload("res://characters/additive_treasure.tscn")

var npcs = []

func get_width():
	return ($CollisionShape2D.shape as RectangleShape2D).extents.x * 2

func _ready():
	add_to_group(Constants.fight_place_group)
	
	assert(character_power.size() == character_type.size(), "Arrays' size must be the same")
	
	var number_of_characters = character_power.size()
	var number_of_characters_not_player = 0
	for type in character_type:
		if type != CharacterType.PLAYER:
			number_of_characters_not_player += 1
	
	for i in range(0, number_of_characters, 1):
		var character: Character
		
		if character_type[i] == CharacterType.PLAYER:
			character = PlayerResource.instance()
			var player_position = Vector2()
			player_position.x = -get_width() / 2 + character.get_width() / 2 + 5
			character.position = player_position
		else:
			if character_type[i] == CharacterType.ENNEMY:
				character = EnnemyResource.instance()
			elif character_type[i] == CharacterType.ADDITIVE_TREASURE:
				character = AdditiveTreasureResource.instance()
			var character_position = Vector2()
			character_position.x = get_width() / 2 - character.get_width() / 2 - 5 - 105*(number_of_characters_not_player - npcs.size() - 1)
			character.position = character_position
			npcs.append(character)
		character.set_power(character_power[i])
		add_child(character)

func add_player(player: Player):
	_move_player(player)

func _move_player(player: Player):
	player.input_pickable = false
	player.get_parent().remove_child(player)
	add_child(player)
	var player_position = Vector2()
	player_position.x =  -get_width() / 2 + player.get_width() / 2 + 5
	player.position = player_position
	yield(get_tree().create_timer(1.0), "timeout")
	_handle_interaction(player)
	
func _handle_interaction(player: Player):
	var character = npcs[0]
	var victory: bool
	if character is Ennemy:
		victory = _fight(player, character)	
	elif character is AdditiveTreasure:
		_take_treasure(player, character)
		victory = true
	
	if victory:
		npcs.remove(0)
		if !npcs.empty():
			yield(get_tree().create_timer(1.0), "timeout")
			_handle_interaction(player)
		else:
			player.input_pickable = true
			emit_signal("place_cleared")
	else:
		player.emit_signal("player_died")

func _fight(player: Player, ennemy: Ennemy):
	if player.power > ennemy.power:
		player.set_power(player.power + ennemy.power)
		ennemy.queue_free()
		return true
	else:
		ennemy.power += player.power
		player.queue_free()
		return false

func _take_treasure(player: Player, treasure: AdditiveTreasure):
	player.set_power(player.power + treasure.power)
	treasure.queue_free()
