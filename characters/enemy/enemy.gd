extends Character

class_name Enemy

@onready var animation = $AnimatedSprite2D

var rng = RandomNumberGenerator.new()
var type = ""
var alive = true

func _ready():
	var type_id = rng.randi_range(1, 1)
	if type_id == 1:
		type="orc"
	var time_to_wait_ms = rng.randi_range(0, 1000) / 1000.0
	await get_tree().create_timer(time_to_wait_ms).timeout
	animation.play(type + "_idle")

func enemy_died():
	alive = false
	animation.play(type + "_death")

func attack():
	var attack_id = rng.randi_range(1, 2)
	animation.play(type + "_attack" + str(attack_id))
	await animation.animation_finished


func _on_animation_finished():
	if alive:
		animation.play(type + "_idle")
	else:
		queue_free()
		get_parent().remove_child(self)
