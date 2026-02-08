extends Node

class_name Lobby

func _on_play_button_pressed() -> void:
    Game.change_state(Enums.GameState.STAGE)
    Game.stage.start(load("res://data/stages/intro.tres") as StageResource)
