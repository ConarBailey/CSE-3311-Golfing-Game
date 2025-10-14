extends RigidBody2D

signal strokesChange(st)
signal time
signal cameraChange(x,y)
signal updateText(stri)
@export var speed = 1000
@export var shotEnable = 25
@export var maxforce = 70000
var strokes = 0
var startingx = 0
var startingy = 0
var TimerEnable = true
var StrokesTotal = [0,0,0,0,0,0,0,0,0]

func _moveBallTo(x: int,y: int) -> void:
	startingx = x
	startingy = y
	global_position.x = x
	global_position.y = y
	strokes = 0
	linear_velocity.x = 0
	linear_velocity.y = 0
	angular_velocity = 0

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
	angular_velocity = 0
	global_position.x = startingx
	global_position.y = startingy
	##print("out of bounds detected")

func _on_timer_timeout() -> void:
	TimerEnable = true

func _on_hole_1_body_entered(body: Node2D) -> void:
	##print("Strokes - " + str(strokes))
	if(body is RigidBody2D):
		updateText.emit("Hole 2\nPar - 3\nStrokes - 0")
		StrokesTotal[0] = strokes
		_moveBallTo(2145,520)
		cameraChange.emit(3135,290)

func _on_hole_2_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		updateText.emit("Hole 3\nPar - 5\nStrokes - 0")
		StrokesTotal[1] = strokes
		_moveBallTo(4705,550)
		cameraChange.emit(5725,290)

func _on_hole_3_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		updateText.emit("Hole 4\nPar - 4\nStrokes - 0")
		StrokesTotal[2] = strokes
		_moveBallTo(7325,220)
		cameraChange.emit(8350,290)

func _on_hole_4_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		updateText.emit("Hole 5\nPar - 5\nStrokes - 0")
		StrokesTotal[3] = strokes
		_moveBallTo(9950,20)
		cameraChange.emit(10975,290)

func _on_hole_5_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		updateText.emit("Hole 6\nPar - 6\nStrokes - 0")
		StrokesTotal[4] = strokes
		_moveBallTo(12575,80)
		cameraChange.emit(13600,290)

func _on_hole_6_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		updateText.emit("Hole 7\nPar - 6\nStrokes - 0")
		StrokesTotal[5] = strokes
		_moveBallTo(15200,400)
		cameraChange.emit(16220,290)

func _on_hole_7_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		updateText.emit("Hole 8\nPar - 10\nStrokes - 0")
		StrokesTotal[6] = strokes
		_moveBallTo(17745,150)
		cameraChange.emit(18825,290)

func _on_hole_8_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		updateText.emit("Hole 9\nPar - 6\nStrokes - 0")
		StrokesTotal[7] = strokes
		_moveBallTo(20375,465)
		cameraChange.emit(21475,290)

func _on_hole_9_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		StrokesTotal[8] = strokes
		var sum = 0
		for i in StrokesTotal:
			sum += i
		updateText.emit("Level Pack\n Complete!\nTotal Strokes\n" + str(sum))
