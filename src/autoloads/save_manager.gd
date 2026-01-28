extends Node

var current_save: SaveData

func new():
    current_save = SaveData.new()

func load_save(slot: String):
    current_save = ResourceLoader.load("user://saves/%s.tres" % slot)

func save_save(slot: String):
    ResourceSaver.save(current_save, "user://saves/%s.tres" % slot)