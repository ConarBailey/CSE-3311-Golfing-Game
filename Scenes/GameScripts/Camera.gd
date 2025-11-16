extends Camera2D

func _on_ball_camera_change(node: Node2D) -> void:
	global_position.x = node.global_position.x
	global_position.y = node.global_position.y
