extends Control

@export var amplitude: float = 10.0 
@export var frequency: float = 1.0  

var initial_y_position: float
var start_time: float  

func _ready() -> void:
	initial_y_position = position.y
	start_time = Time.get_ticks_msec() / 1000.0 

func _process(delta: float) -> void:
	var elapsed_time = (Time.get_ticks_msec() / 1000.0) - start_time

	var sine_wave_offset = amplitude * sin(frequency * elapsed_time)

	position.y = initial_y_position + sine_wave_offset
