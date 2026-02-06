extends Node

var current_save: SaveData

func new_save():
    current_save = SaveData.new()

func get_saves() -> Array[String]:
    var dir = DirAccess.open("user://saves/")
    var saves: Array[String] = []
    if dir:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name != "":
            if file_name.ends_with(".tres"):
                saves.append(file_name.replace(".tres", ""))
            file_name = dir.get_next()
        dir.list_dir_end()
    return saves

func load_save(slot: String):
    current_save = ResourceLoader.load("user://saves/%s.tres" % slot)

func save_save(slot: String = ""):
    if slot == "":
        slot = "slot0"
    ResourceSaver.save(current_save, "user://saves/%s.tres" % slot)
