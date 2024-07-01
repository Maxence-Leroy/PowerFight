extends Area2D

class_name FightPlace

signal place_cleared

enum CharacterType {PLAYER, ENEMY, ADDITIVE_TREASURE }
@export var character_power: Array[int]
@export var character_type: Array[CharacterType]
@export var character_objective: Array[bool]

const EnemyResource = preload("res://characters/enemy/enemy.tscn")
const PlayerResource = preload("res://characters/player/player.tscn")
const AdditiveTreasureResource = preload("res://characters/additive_treasure/additive_treasure.tscn")

const player_speed = 50

var rng = RandomNumberGenerator.new()
var npcs = []
var _player: Player = null

func get_width():
	return ($CollisionShape2D.shape as RectangleShape2D).extents.x * 2

func get_height():
	return ($CollisionShape2D.shape as RectangleShape2D).extents.y * 2

func _ready():
	add_to_group(Constants.fight_place_group)
	
	assert(character_power.size() == character_type.size(), "Arrays' size must be the same")
	assert(character_power.size() == character_objective.size(), "Arrays' size must be the same")
	
	var number_of_characters = character_power.size()
	var number_of_characters_not_player = 0
	for type in character_type:
		if type != CharacterType.PLAYER:
			number_of_characters_not_player += 1
	
	for i in range(0, number_of_characters, 1):
		var character: Character
		
		if character_type[i] == CharacterType.PLAYER:
			character = PlayerResource.instantiate()
			var player_position = Vector2()
			player_position.x = -get_width() / 2 + character.get_width() / 2 + 5
			character.position = player_position
		else:
			if character_type[i] == CharacterType.ENEMY:
				character = EnemyResource.instantiate()
			elif character_type[i] == CharacterType.ADDITIVE_TREASURE:
				character = AdditiveTreasureResource.instantiate()
			var character_position = Vector2()
			character_position.x = get_width() / 2 - character.get_width() / 2 - 5 - 105*(number_of_characters_not_player - npcs.size() - 1)
			character.position = character_position
			npcs.append(character)
		character.position.y = Constants.y_offset_character_in_place
		character.set_power(character_power[i])
		if character_objective[i]:
			character.set_is_objective()
		add_child(character)

func add_player(player: Player):
	_move_player(player)

func _move_player(player: Player):
	player.input_pickable = false
	player.get_parent().remove_child(player)
	add_child(player)
	var player_position = Vector2()
	player_position.x =  -get_width() / 2 + player.get_width() / 2 + 5
	player_position.y = Constants.y_offset_character_in_place
	player.position = player_position
	await get_tree().create_timer(1.0).timeout
	_handle_interaction(player)

func _process(delta):
	if _player != null:
		_player.position.x += player_speed * delta

func _handle_interaction(player: Player):
	if !npcs.is_empty():
		var character = npcs[0]
		var victory: bool
		if character is Enemy:
			victory = await _fight(player, character)	
		elif character is AdditiveTreasure:
			_take_treasure(player, character)
			victory = true
		
		if victory:
			npcs.remove_at(0)
			if !npcs.is_empty():
				await get_tree().create_timer(1.0).timeout
				_handle_interaction(player)
			else:
				player.input_pickable = true
				emit_signal("place_cleared")
		else:
			player.player_died()
	else:
		player.input_pickable = true

func _fight(player: Player, enemy: Enemy):
	var distance = enemy.position.x - player.position.x - enemy.get_width()
	_player = player
	player.animation.play("walk")
	await get_tree().create_timer(distance / player_speed).timeout
	_player = null
	var attack_id = rng.randi_range(1,3)
	player.animation.play("attack" + str(attack_id))
	await get_tree().create_timer(2).timeout
	if player.power > enemy.power:
		player.set_power(player.power + enemy.power)
		enemy.queue_free()
		remove_child(enemy)
		return true
	else:
		enemy.power += player.power
		return false

func _take_treasure(player: Player, treasure: AdditiveTreasure):
	var distance = treasure.position.x - player.position.x
	_player = player
	player.animation.play("walk")
	await get_tree().create_timer(distance / player_speed).timeout
	_player = null
	player.animation.play("heal")
	player.set_power(player.power + treasure.power)
	treasure.queue_free()
	remove_child(treasure)
