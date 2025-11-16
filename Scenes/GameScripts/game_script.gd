extends Node2D

#@onready var score_results: Label = $PausePanel/ScoreResults
@onready var end_game_menu: Control = $UI/EndGameMenu
@onready var ball: RigidBody2D = $Ball

var user_score
var user_score_value
var level: String

var LevelPars = {
	"Level 1": [3, 5, 4, 5, 6, 6, 10, 6, 6],
	"Level 2": [3, 5, 4, 5, 6, 6, 10, 6, 6],
}

const LEVEL_SCENES = {
	"Level 1": "res://Scenes/level_1.tscn",
	"Level 2": "res://Scenes/level_2.tscn",
	"Level 3": "res://Scenes/level_3.tscn",
	"Level E": "res://Scenes/level_E.tscn",
}

func _ready() -> void:
	level = _get_current_level_name()

func _get_current_level_name() -> String:
	var file_name = get_tree().current_scene.scene_file_path.get_file().get_basename()
	var parts = file_name.split("_") 
	if parts.size() > 1:
		var num_text = parts[1]
		return "Level " + num_text
	return "Unknown Level"


func _on_ball_end_game(stroke_totals: Array):
	var hole_pars = LevelPars.get(level, [])
	print(hole_pars)
	var total_strokes = 0
	var total_par = 0

	for i in range(len(stroke_totals)):
		total_strokes += stroke_totals[i]
		total_par += hole_pars[i]
		
	user_score_value = total_strokes - total_par
	user_score = str(total_strokes) + "/" + str(total_par)

	end_game_menu.end_game(stroke_totals, hole_pars, user_score)

func _next_level():
	var current_index = _get_level_index(level)
	var next_level_name = "Level " + str(current_index + 1)
	
	print(next_level_name)
	if LEVEL_SCENES.has(next_level_name):
		var next_scene_path = LEVEL_SCENES[next_level_name]
		var next_scene = load(next_scene_path)
		if next_scene:
			get_tree().change_scene_to_packed(next_scene)
	else:
		print("✅ No more levels available. Game complete!")


func _get_level_index(level_name: String) -> int:
	var parts = level_name.split(" ")
	if parts.size() > 1 and parts[1].is_valid_int():
		return int(parts[1])
	return 1
