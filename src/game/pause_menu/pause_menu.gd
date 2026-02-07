extends Control

class_name PauseMenu

@export var saves_container: VBoxContainer
@export var save_name_line_edit: LineEdit

func _on_save_pressed() -> void:
    var slot_name := save_name_line_edit.text
    if slot_name == "":
        slot_name = "slot0"
    SaveManager.save_save(slot_name)

func _ready() -> void:
    var save_entry_scene: PackedScene = preload("res://src/game/pause_menu/save_load_entry.tscn")
    var saves: Array[String] = SaveManager.get_saves()
    for save in saves:
        var save_entry_instance: MarginContainer = save_entry_scene.instantiate()
        save_entry_instance.set("slot_name", save)
        save_entry_instance.get_node("Button").connect("pressed", Callable(self , "_on_save_pressed"))
        saves_container.add_child(save_entry_instance)


func _on_color_rect_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        queue_free()
        get_tree().paused = false

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        queue_free()
        get_tree().paused = false
