extends Control


@onready var score_results: Label = $Panel/ScoreResults
@onready var leaderboard: Node2D = $Leaderboard
var score_text = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func end_game(stroke_totals: Array, hole_pars: Array, user_score: String) -> void:
	self.show()
	var total_strokes = 0
	for s in stroke_totals:
		total_strokes += s

	# Split the user_score string to show strokes and par separately
	var parts = user_score.split("/")
	var strokes = parts[0]
	var par = parts[1]

	# Compute over/under par difference
	var diff = int(strokes) - int(par)
	var diff_text = ""
	if diff == 0:
		diff_text = "Even Par"
	elif diff > 0:
		diff_text = "+%d over par" % diff
	else:
		diff_text = "%d under par" % abs(diff)

	score_results.text = "Final Score: %s (%s)" % [user_score, diff_text]



func _on_leaderboard_pressed() -> void:
	leaderboard.show()
