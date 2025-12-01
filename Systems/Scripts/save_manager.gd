extends Node

const WORST_SCORE = 99999 

var scores = {
	"Level 1 - Bumpy Plains": "-",
	"Level 2 - Fungal Forest": "-",
	"Level 3 - The Grand Desert": "-",
	"Level 4 - Frozen Underworld": "-",
	"Level EX - The Laboratory": "-"
}

func get_numeric_strokes(score_string: String) -> int:
	if score_string == "-":
		return WORST_SCORE
	var parts = score_string.split("/")
	if parts.size() > 0 and parts[0].is_valid_int():
		return int(parts[0])
	return WORST_SCORE


func get_level_score(level_name: String) -> String:
	if FileAccess.file_exists("user://scores.save"):
		var file = FileAccess.open("user://scores.save", FileAccess.READ)
		var loaded_scores = file.get_var()
		file.close()
		scores = loaded_scores
	return scores.get(level_name, "-")

func save_score(level_name: String, score: String):
	scores[level_name] = score
	var file = FileAccess.open("user://scores.save", FileAccess.WRITE)
	file.store_var(scores)
	file.close()

func load_scores():
	if FileAccess.file_exists("user://scores.save"):
		var file = FileAccess.open("user://scores.save", FileAccess.READ)
		scores = file.get_var()
		file.close()
