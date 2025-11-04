extends Node2D

const level = "level1"

@onready var score_results: Label = $PausePanel/ScoreResults
@onready var end_game_menu: Control = $UI/EndGameMenu
@onready var ball: RigidBody2D = $Ball

var user_score
var user_score_value

var LevelPars = {
	"level1": [3, 5, 4, 5, 6, 6, 10, 6, 6],
	"level2": [4, 4, 5, 3, 6, 5, 7, 4, 6],
	"level3": [5, 4, 4, 5, 5, 6, 6, 5, 4]
}

func _ready() -> void:
	ball.endGame.connect(_on_ball_end_game)


func _on_ball_end_game(stroke_totals: Array):
	var hole_pars = LevelPars[level]
	var total_strokes = 0
	var total_par = 0

	for i in range(len(stroke_totals)):
		total_strokes += stroke_totals[i]
		total_par += hole_pars[i]
		
	user_score_value = total_strokes - total_par
	user_score = str(total_strokes) + "/" + str(total_par)

	end_game_menu.end_game(stroke_totals, hole_pars, user_score)

	
