extends Character

class_name AdditiveTreasure

@onready var animation = $AnimatedSprite2D

var rng = RandomNumberGenerator.new()

func wait_before_starting_animation():
	var time_to_wait_ms = rng.randi_range(0, 4000) / 1000.0
	await get_tree().create_timer(time_to_wait_ms).timeout
	animation.play("heart")

func _on_animation_ended():
	wait_before_starting_animation()

func _ready():
	wait_before_starting_animation()

