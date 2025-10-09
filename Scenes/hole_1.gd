extends Camera2D


func _on_ball_camera_change(x: Variant, y: Variant) -> void:
	global_position.x = x
	global_position.y = y
