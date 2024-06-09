extends Control

@export var number_of_level: int = 0

@onready var vbox: VBoxContainer = $VBoxContainer
@onready var level_grid: GridContainer = $VBoxContainer/GridContainer

func _ready():
	vbox.add_theme_constant_override("separation",50)
	level_grid.add_theme_constant_override("v_separation",10)
	for i in range(1, number_of_level + 1):
		var button = Button.new()
		button.text = str(i)
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		button.custom_minimum_size = Vector2(0, 50)
		button.connect("pressed", Callable(self, "_on_press_level_selection").bind(i))
		level_grid.add_child(button)

func _on_press_level_selection(level: int):
	Constants.current_stage = level - 1
	Constants.go_to_next_level()
