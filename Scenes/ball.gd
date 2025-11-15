extends RigidBody2D

signal strokesChange(st)
signal time
signal cameraChange(x,y)
signal updateText(stri)
signal endGame(scoreInfo)

@export var speed = 1000
@export var shotEnable = 5
@export var maxforce = 70000
var strokes = 0
var startingx = 0
var startingy = 0
var TimerEnable = true
var StrokesTotal = [0,0,0,0,0,0,0,0,0]

var spawn_position
var is_aiming = false
var aim_start_pos = Vector2.ZERO
var aim_current_pos = Vector2.ZERO
var aim_line

func _ready():
	spawn_position = global_position  
	aim_line = $AimLine
	aim_line.clear_points()

func _physics_process(delta: float) -> void:
	if linear_velocity.length() < 10:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		
func _process(_delta):
	
	if is_aiming:
		aim_current_pos = get_global_mouse_position()
		var direction = aim_start_pos - aim_current_pos
		var max_length = 200  
		var line_vector = direction.limit_length(max_length)
		
		aim_line.clear_points()
		aim_line.add_point(Vector2.ZERO)
		aim_line.add_point(to_local(aim_start_pos + line_vector))

func _input(event: InputEvent) -> void:
	# Restart level
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		_restart_level()
		return

	# Start aiming
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
		if event.pressed:
			if linear_velocity.length() < shotEnable and TimerEnable:
				is_aiming = true
				aim_start_pos = position

		# Release - shoot
		else:
			if is_aiming and linear_velocity.length() < shotEnable and TimerEnable:
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

			is_aiming = false
			aim_line.clear_points()  # Hide line



func _moveBallTo(x: int,y: int) -> void:
	startingx = x
	startingy = y
	global_position.x = x
	global_position.y = y
	strokes = 0
	linear_velocity.x = 0
	linear_velocity.y = 0
	angular_velocity = 0

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
		endGame.emit(StrokesTotal)
	

func _restart_level():
	# Work In Progress
	global_position = spawn_position 
	startingx = spawn_position.x
	startingy = spawn_position.y
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	strokes = 0
	strokesChange.emit(strokes)
