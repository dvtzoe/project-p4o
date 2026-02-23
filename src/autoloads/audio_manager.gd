# AudioManager.gd
# ระบบจัดการเสียงของเกม
# ใช้ได้ใน scene ทั้งหมด

extends Node


# ตัวแปรเก็บค่า volume (0-100)
var master_volume = 100
var music_volume = 100
var sfx_volume = 100

# ตัวแปรเก็บ node สำหรับเล่นเสียง
var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

func _ready():
    # ตั้งชื่อให้ node นี้เพื่อให้เรียกได้ง่าย
    name = "AudioManager"
    
    # สร้าง AudioStreamPlayer สำหรับ music
    music_player = AudioStreamPlayer.new()
    music_player.bus = "Music" # ใช้ bus ชื่อ "Music" (เราจะสร้างใน Godot ทีหลัง)
    add_child(music_player)
    
    # สร้าง AudioStreamPlayer สำหรับ sfx
    sfx_player = AudioStreamPlayer.new()
    sfx_player.bus = "SFX" # ใช้ bus ชื่อ "SFX"
    add_child(sfx_player)
    
    # โหลดค่า volume ที่เคยบันทึก
    load_volume_settings()
    update_volumes()

# ฟังก์ชันเล่นเพลง
func play_music(audio_file: String):
    if music_player:
        music_player.stream = load(audio_file)
        music_player.play()

# ฟังก์ชันเล่นเสียง (sfx)
func play_sfx(audio_file: String):
    if sfx_player:
        sfx_player.stream = load(audio_file)
        sfx_player.play()

# ฟังก์ชันหยุด music
func stop_music():
    if music_player:
        music_player.stop()

# อัปเดต volume ทั้งหมด
func update_volumes():
    var master_idx = AudioServer.get_bus_index("Master")
    var music_idx = AudioServer.get_bus_index("Music")
    var sfx_idx = AudioServer.get_bus_index("SFX")

    if master_idx != -1:
        AudioServer.set_bus_mute(master_idx, master_volume == 0)
        AudioServer.set_bus_volume_db(master_idx, linear_to_db(master_volume / 100.0))
    if music_idx != -1:
        AudioServer.set_bus_volume_db(music_idx, linear_to_db(music_volume / 100.0))
    if sfx_idx != -1:
        AudioServer.set_bus_volume_db(sfx_idx, linear_to_db(sfx_volume / 100.0))

func save_volume_settings():
    var config = ConfigFile.new()
    config.set_value("audio", "master", master_volume)
    config.set_value("audio", "music", music_volume)
    config.set_value("audio", "sfx", sfx_volume)
    config.save("user://settings.cfg")

# โหลดค่า volume จาก file
func load_volume_settings():
    var config = ConfigFile.new()
    var error = config.load("user://settings.cfg")
    
    if error == OK:
        master_volume = config.get_value("audio", "master", 100)
        music_volume = config.get_value("audio", "music", 100)
        sfx_volume = config.get_value("audio", "sfx", 100)
