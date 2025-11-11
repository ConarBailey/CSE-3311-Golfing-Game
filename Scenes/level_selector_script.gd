extends Panel

const LEVELS = {
	"Level 1": preload("res://Scenes/level_1.tscn"),
	"Level 2": preload("res://Scenes/level_2.tscn"),
}

@onready var level_container: VBoxContainer = $LevelContainer 
@onready var dummy_button: Button = $LevelContainer/StarterButton

func _ready() -> void:
	hide()
	dummy_button.queue_free()
	
	for level_name in LEVELS.keys():
		var btn := Button.new()
		btn.text = level_name
		btn.add_theme_font_size_override("font_size", 40)
		btn.custom_minimum_size = Vector2(200, 100)
		level_container.add_child(btn)
		btn.pressed.connect(_on_level_button_pressed.bind(level_name))

func _on_level_button_pressed(level_name: String) -> void:
	var scene_to_load = LEVELS[level_name]
	get_tree().change_scene_to_packed(scene_to_load)
