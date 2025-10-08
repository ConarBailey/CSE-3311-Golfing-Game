extends RigidBody2D

signal strokesChange(st)
signal time
@export var speed = 1000
@export var shotEnable = 25
@export var maxforce = 60000
var strokes = 0
var startingx = 0
var startingy = 0
var TimerEnable = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.pressed and (linear_velocity.x < shotEnable and linear_velocity.y < shotEnable) and TimerEnable:
		startingx = global_position.x
		startingy = global_position.y
		var force = (position - get_global_mouse_position())*speed
		if force.x > maxforce:
			force.x = maxforce
		if force.y > maxforce:
			force.y = maxforce
		if force.x < -maxforce:
			force.x = -maxforce
		if force.y < -maxforce:
			force.y = -maxforce
		apply_central_force(force)
		##print(global_position - get_global_mouse_position())
		strokes = strokes + 1
		strokesChange.emit(strokes)
		TimerEnable = false
		time.emit()

func _on_right_body_exited(_body: Node2D) -> void:
	linear_velocity.x = 0
	linear_velocity.y = 0
	global_position.x = startingx
	global_position.y = startingy
	##print("out of bounds detected")

func _on_timer_timeout() -> void:
	TimerEnable = true
