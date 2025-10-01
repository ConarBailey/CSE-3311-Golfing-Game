extends Control

@export var level_scene : PackedScene

@onready var main_panel: Panel = $MainPanel
@onready var settings_panel: Panel = $SettingsPanel
@onready var credits_panel: Panel = $CreditsPanel

func show_panel(target_panel : Panel) -> void:
	main_panel.hide()
	settings_panel.hide()
	credits_panel.hide()
	target_panel.show()
	
func close_panel() -> void:
	settings_panel.hide()
	credits_panel.hide()
	main_panel.show()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(level_scene)


func _on_settings_pressed() -> void:
	show_panel(settings_panel)


func _on_credits_pressed() -> void:
	show_panel(credits_panel)


func _on_quit_pressed() -> void:
	get_tree().quit()
