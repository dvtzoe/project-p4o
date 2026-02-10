extends Control

class_name PauseMenu

@export var saves_container: VBoxContainer
@export var save_name_line_edit: LineEdit

const SAVE_ENTRY_SCENE := preload("res://src/game/pause_menu/save_load_entry.tscn")

func _on_save_pressed(slot_name: String) -> void:
    if slot_name == null:
        slot_name = save_name_line_edit.text
    if slot_name == "":
        slot_name = "slot0"
    SaveManager.save_save(slot_name)
    refresh_saves_list()

func _ready() -> void:
    refresh_saves_list()

func _on_color_rect_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        Game.pause_menu = null
        queue_free()

func refresh_saves_list() -> void:
    for child in saves_container.get_children():
        child.queue_free()
    var saves: Array[String] = SaveManager.get_saves()
    for save in saves:
        var save_entry_instance := SAVE_ENTRY_SCENE.instantiate()
        save_entry_instance.setup(save)
        save_entry_instance.connect("pressed", Callable(self , "_on_save_pressed").bind(save))
        saves_container.add_child(save_entry_instance)
