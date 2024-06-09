extends Control

export(int) var number_of_level = 0

onready var vbox: VBoxContainer = $VBoxContainer
onready var level_grid: GridContainer = $VBoxContainer/GridContainer

func _ready():
	vbox.add_constant_override("separation",50)
	level_grid.add_constant_override("vseparation",10)
	for i in range(1, number_of_level + 1):
		var button = Button.new()
		button.text = str(i)
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		button.rect_min_size = Vector2(0, 50)
		button.connect("pressed", self, "_on_press_level_selection", [i])
		level_grid.add_child(button)

func _on_press_level_selection(level: int):
	Constants.current_stage = level - 1
	Constants.go_to_next_level()
