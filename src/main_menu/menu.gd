extends Control

@export var play_button: Button


func _on_new_button_pressed() -> void:
    SaveManager.new()
    get_tree().change_scene_to_file("res://src/game/game.tscn")


func _on_load_button_pressed() -> void:
    SaveManager.load_save("slot0")
    get_tree().change_scene_to_file("res://src/game/game.tscn")
