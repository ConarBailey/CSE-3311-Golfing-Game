extends Label

func _on_ball_strokes_change(st: Variant) -> void:
	var tempText = text.split("\n")
	tempText[2] = "Strokes - " + str(st)
	text = tempText[0] + "\n" + tempText[1] + "\n" + tempText[2]
	
func _on_ball_update_text(stri: Variant) -> void:
	text = str(stri)
