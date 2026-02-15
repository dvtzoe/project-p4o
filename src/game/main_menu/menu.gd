extends Control

class_name MainMenu

@export var play_button: Button


func _on_new_button_pressed() -> void:
    SaveManager.new_save()
    Game.change_state(Game.States.PLACE)


func _on_load_button_pressed() -> void:
    if SaveManager.has_save("slot0"):
        SaveManager.load("slot0")
        Game.change_state(Game.States.PLACE)
