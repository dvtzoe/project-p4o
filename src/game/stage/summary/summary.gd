extends Control

class_name StageSummary

@export var return_button: Button

func _on_return_button_pressed() -> void:
    Game.change_state(Game.States.PLACE)

func _on_all_objectives_completed() -> void:
    visible = true

func _ready() -> void:
    return_button.pressed.connect(_on_return_button_pressed)
    Game.stage.objective.all_objectives_completed.connect(_on_all_objectives_completed)