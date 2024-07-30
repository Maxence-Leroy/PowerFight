extends Character

class_name SubtractionTreasure

@onready var animation = $AnimatedSprite2D

var rng = RandomNumberGenerator.new()

func treasure_taken():
	animation.play("bomb_used")
	await animation.animation_finished
	queue_free()
	get_parent().remove_child(self)

func _ready():
	var time_to_wait_ms = rng.randi_range(0, 4000) / 1000.0
	await get_tree().create_timer(time_to_wait_ms).timeout
	animation.play("bomb_idle")

