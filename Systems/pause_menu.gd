extends Control

@onready var pause_panel: Panel = $PausePanel
@onready var settings_panel: Panel = $SettingsPanel

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if self.visible == false:
			pause_game()
		else:
			resume_game()
			
func resume_game() -> void:
	self.hide()
	get_tree().paused = false
	
func pause_game() -> void:
	self.show()    
	get_tree().paused = true

func _on_resume_pressed() -> void:
	resume_game()

func _on_settings_pressed() -> void:
	pause_panel.hide()
	settings_panel.show()


func _on_main_menu_pressed() -> void:
	resume_game()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_close_settings_pressed() -> void:
	settings_panel.hide()
	pause_panel.show()


func _on_pause_button_pressed() -> void:
	pause_game()
