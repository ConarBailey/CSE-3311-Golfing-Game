extends Label

func _on_ball_strokes_change(st: Variant) -> void:
	text = "Hole 1\nPar - 3\nStrokes - " + str(st)
