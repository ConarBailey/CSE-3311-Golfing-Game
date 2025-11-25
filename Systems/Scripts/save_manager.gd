extends Node

var scores = {
	"Level 1 - Bumpy Plains": "-",
	"Level 2 - Fungal Forest": "-",
	"Level 3 - The Grand Desert": "-",
	"Level EX - The Laboratory": "-"
}

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
