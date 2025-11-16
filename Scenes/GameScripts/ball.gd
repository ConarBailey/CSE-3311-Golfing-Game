extends RigidBody2D

signal strokesChange(st)
signal time
signal cameraChange(node)
signal updateText(stri)
signal endGame(scoreInfo)

@export var speed = 1000
@export var shotEnable = 5
@export var maxforce = 70000
var currentHole = 1
var strokes = 0
var startingx = 0
var startingy = 0
var prevgrav = 1
var prevforce = Vector2(0,0)
var TimerEnable = true
var StrokesTotal = [0,0,0,0,0,0,0,0,0]
var spawn_position
var HoleInfo
var CameraInfo
var HolePars
var is_aiming = false
var aim_start_pos = Vector2.ZERO
var aim_current_pos = Vector2.ZERO
var aim_line

func _ready():
	spawn_position = global_position  
	aim_line = $AimLine
	aim_line.clear_points()
	HoleInfo = get_node("Holes").get_children()
	CameraInfo = get_node("CameraPositions").get_children()
	HolePars = $Holes.HolePars

func _physics_process(_delta: float) -> void:
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
				prevgrav = gravity_scale
				prevforce = constant_force
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

func _moveBallTo(node) -> void:
	prevforce = Vector2(0,0)
	prevgrav = 1
	var x = node.global_position.x
	var y = node.global_position.y
	linear_velocity.x = 0
	linear_velocity.y = 0
	angular_velocity = 0
	startingx = x
	startingy = y
	global_position.x = x
	global_position.y = y
	strokes = 0

func _on_right_body_exited(_body: Node2D) -> void:
	linear_velocity.x = 0
	linear_velocity.y = 0
	angular_velocity = 0
	gravity_scale = prevgrav
	constant_force = prevforce
	global_position.x = startingx
	global_position.y = startingy

func _on_timer_timeout() -> void:
	TimerEnable = true
		
func _on_holes_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		if(currentHole == 9):
			StrokesTotal[8] = strokes
			var sum = 0
			for i in StrokesTotal:
				sum += i
			updateText.emit("Level Pack\n Complete!\nTotal Strokes\n" + str(sum))
			#endGame.emit(StrokesTotal)
		else:
			StrokesTotal[currentHole-1] = strokes
			_moveBallTo(HoleInfo[currentHole])
			cameraChange.emit(CameraInfo[currentHole])
			currentHole += 1
			updateText.emit("Hole " + str(currentHole) + "\nPar - "+ str(HolePars[currentHole-1]) + "\nStrokes - 0")

func _restart_level():
	# Work In Progress
	global_position = spawn_position 
	startingx = spawn_position.x
	startingy = spawn_position.y
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	strokes = 0
	strokesChange.emit(strokes)

func _on_left_push_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		constant_force = Vector2(-980,0)
		gravity_scale = 0

func _on_right_push_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		constant_force = Vector2(980,0)
		gravity_scale = 0

func _on_down_push_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		constant_force = Vector2(0,0)
		gravity_scale = 1

func _on_up_push_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		constant_force = Vector2(0,0)
		gravity_scale = -1

func _on_no_grav_body_entered(body: Node2D) -> void:
	if(body is RigidBody2D):
		constant_force = Vector2(0,0)
		gravity_scale = 0
		
