extends Node

const SAVE_DIR := "user://saves/"

var current_save: SaveData

func new_save() -> void:
    current_save = SaveData.new()

func save(slot: String = "") -> bool:
    if slot == "":
        slot = "slot0"
    if current_save == null:
        push_error("SaveManager: No active save to write.")
        return false

    _ensure_save_dir()
    var path := SAVE_DIR + slot + ".json"
    var file := FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        push_error("SaveManager: Could not open %s for writing: %s" % [path, FileAccess.get_open_error()])
        return false

    var json_string := JSON.stringify(current_save.to_dict(), "\t")
    file.store_string(json_string)
    return true

func load(slot: String) -> bool:
    var path := SAVE_DIR + slot + ".json"
    if not FileAccess.file_exists(path):
        push_error("SaveManager: Save file not found: %s" % path)
        return false

    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        push_error("SaveManager: Could not open %s for reading: %s" % [path, FileAccess.get_open_error()])
        return false

    var json_string := file.get_as_text()
    var parsed = JSON.parse_string(json_string)
    if parsed == null:
        push_error("SaveManager: Failed to parse JSON in %s" % path)
        return false

    current_save = SaveData.from_dict(parsed)
    return true

func delete(slot: String) -> bool:
    var path := SAVE_DIR + slot + ".json"
    if not FileAccess.file_exists(path):
        return false
    return DirAccess.remove_absolute(path) == OK

func has_save(slot: String) -> bool:
    return FileAccess.file_exists(SAVE_DIR + slot + ".json")

func get_saves() -> Array[Dictionary]:
    _ensure_save_dir()
    var saves: Array[Dictionary] = []
    var dir := DirAccess.open(SAVE_DIR)
    if dir == null:
        return saves
    dir.list_dir_begin()
    var file_name := dir.get_next()
    while file_name != "":
        if file_name.ends_with(".json"):
            var slot := file_name.replace(".json", "")
            var meta := _read_save_meta(slot)
            if meta.size() > 0:
                saves.append(meta)
        file_name = dir.get_next()
    dir.list_dir_end()
    saves.sort_custom(func(a, b): return a.get("saved_at", "") > b.get("saved_at", ""))
    return saves

func _read_save_meta(slot: String) -> Dictionary:
    var path := SAVE_DIR + slot + ".json"
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return {}
    var parsed = JSON.parse_string(file.get_as_text())
    if parsed == null or not parsed is Dictionary:
        return {}
    return {
        "slot": slot,
        "day": parsed.get("day", 0),
        "time": parsed.get("time", 8),
        "route": parsed.get("route", "default"),
        "saved_at": parsed.get("saved_at", ""),
    }

func _ensure_save_dir() -> void:
    if not DirAccess.dir_exists_absolute(SAVE_DIR):
        DirAccess.make_dir_recursive_absolute(SAVE_DIR)
