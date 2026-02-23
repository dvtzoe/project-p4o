extends Control

class_name EnterName

signal name_entered 

@export var line_edit: LineEdit
@export var button: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    button.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
    Config.config.player_name = line_edit.text
    name_entered.emit()
    queue_free()
