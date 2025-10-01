extends Panel

@onready var master_slider: HSlider = $VBoxContainer/Master/MasterSlider
@onready var music_slider: HSlider = $VBoxContainer/Music/MusicSlider
@onready var sfx_slider: HSlider = $VBoxContainer/SFX/SFXSlider
@onready var voice_slider: HSlider = $VBoxContainer/Voice/VoiceSlider

@onready var sync_audio_buses_button: CheckButton = $SyncAudioBusesButton

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("Audio", "Master", 0.5)
		config.set_value("Audio", "Music", 0.5)
		config.set_value("Audio", "SFX", 0.5)
		config.set_value("Audio", "Voice", 0.5)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
		
	load_audio_settings()

func load_audio_settings() -> void:
	master_slider.value = config.get_value("Audio", "Master")
	music_slider.value = config.get_value("Audio", "Music")
	sfx_slider.value = config.get_value("Audio", "SFX")
	voice_slider.value = config.get_value("Audio", "Voice")

	
func save_audio_setting(key: String, value : float):
	config.set_value("Audio", key, value)
	config.save(SETTINGS_FILE_PATH)

func change_bus_volume(bus_name, volume_var, new_value):
	volume_var = linear_to_db(new_value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), volume_var)
	save_audio_setting(bus_name, new_value)

func _on_master_slider_value_changed(value: float) -> void:
	change_bus_volume("Master", master_slider.value, value)
	
	if sync_audio_buses_button.button_pressed == true:
		change_bus_volume("Music", master_slider.value, value)
		music_slider.value = master_slider.value
		
		change_bus_volume("SFX", master_slider.value, value)
		sfx_slider.value = master_slider.value
		
		change_bus_volume("Voice", master_slider.value, value)
		voice_slider.value = master_slider.value


func _on_music_slider_value_changed(value: float) -> void:
	change_bus_volume("Music", music_slider.value, value)


func _on_sfx_slider_value_changed(value: float) -> void:
	change_bus_volume("SFX", sfx_slider.value, value)


func _on_voice_slider_value_changed(value: float) -> void:
	change_bus_volume("Voice", voice_slider.value, value)
