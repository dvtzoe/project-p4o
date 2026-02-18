extends Control
# OptionsMenu.gd - แก้ไข error แล้ว

@onready var master_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/Master/Masterslider
@onready var master_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Master/MasterLabel
@onready var music_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/Music/Musicslider
@onready var music_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Music/MusicLabel
@onready var sfx_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/SFX/SFXslider
@onready var sfx_label: Label = $PanelContainer/MarginContainer/VBoxContainer/SFX/SFXLabel
@onready var text_speed_slider: HSlider = $"PanelContainer/MarginContainer/VBoxContainer/Text Speed/TextSpeedslider"
@onready var text_speed_label: Label = $"PanelContainer/MarginContainer/VBoxContainer/Text Speed/Text speed labelLabel"
@onready var on_quit_bt: Button = $PanelContainer/MarginContainer/VBoxContainer/QuitBt

var audio_manager

func _ready():
	# หา AudioManager
	audio_manager = get_node_or_null("/root/AudioManager")
	if not audio_manager:
		print("❌ ERROR: AudioManager not found!")
		print("   ตรวจสอบว่า AudioManager ในไป Project → Project Settings → Autoload")
		return
	
	print("✓ AudioManager found!")
	
	# ตั้งค่า slider
	setup_sliders()
	
	# เชื่อมต่อ signal
	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	text_speed_slider.value_changed.connect(_on_text_speed_changed)
	on_quit_bt.pressed.connect(_on_quit_bt_pressed)

func setup_sliders():
	# Master Volume
	master_slider.min_value = 1
	master_slider.max_value = 100
	master_slider.value = audio_manager.master_volume
	
	# Music Volume
	music_slider.min_value = 1
	music_slider.max_value = 100
	music_slider.value = audio_manager.music_volume
	
	# SFX Volume
	sfx_slider.min_value = 1
	sfx_slider.max_value = 100
	sfx_slider.value = audio_manager.sfx_volume
	
	# Text Speed
	text_speed_slider.min_value = 1
	text_speed_slider.max_value = 100
	text_speed_slider.step = 1
	text_speed_slider.value = 50
	
	update_labels()

func _on_master_volume_changed(value: float):
	audio_manager.master_volume = int(value)
	audio_manager.update_volumes()
	master_label.text = "Master Volume: %d%%" % int(value)

func _on_music_volume_changed(value: float):
	audio_manager.music_volume = int(value)
	audio_manager.update_volumes()
	music_label.text = "Music Volume: %d%%" % int(value)

func _on_sfx_volume_changed(value: float):
	audio_manager.sfx_volume = int(value)
	audio_manager.update_volumes()
	sfx_label.text = "SFX Volume: %d%%" % int(value)

func _on_text_speed_changed(value: float):
	text_speed_label.text = "Text Speed: %.1fx" % value
	update_story_text_speed(value)

func update_story_text_speed(speed: float):
	# เชื่อมต่อ Story script (แก้ path ตามของจริง)
	var story_node = get_tree().root.get_node_or_null("Stage/Story")
	if story_node:
		story_node.char_interval = 0.05 / speed

func update_labels():
	master_label.text = "Master Volume: %d%%" % audio_manager.master_volume
	music_label.text = "Music Volume: %d%%" % audio_manager.music_volume
	sfx_label.text = "SFX Volume: %d%%" % audio_manager.sfx_volume
	text_speed_label.text = "Text Speed: %.1fx" % text_speed_slider.value


func _on_quit_bt_pressed() -> void:
	#audio_manager.save_volume_settings()
	get_tree().change_scene_to_file("res://src/game/main_menu/menu.tscn")
