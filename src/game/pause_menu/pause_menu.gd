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
    SaveManager.save(slot_name)
    refresh_saves_list()

func _on_load_pressed(slot_name: String) -> void:
    if SaveManager.load(slot_name):
        SigBus.toggle_pause_menu.emit()
        Game.change_state(Game.States.PLACE)

func _ready() -> void:
    refresh_saves_list()

func _on_color_rect_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        SigBus.toggle_pause_menu.emit()

func refresh_saves_list() -> void:
    for child in saves_container.get_children():
        child.queue_free()
    var saves := SaveManager.get_saves()
    for save_meta in saves:
        var slot: String = save_meta["slot"]
        var save_entry_instance := SAVE_ENTRY_SCENE.instantiate()
        var label := "Day %d %02d:00 — %s" % [save_meta["day"], save_meta["time"], slot]
        save_entry_instance.setup(label)
        save_entry_instance.connect("pressed", Callable(self , "_on_save_pressed").bind(slot))
        saves_container.add_child(save_entry_instance)
