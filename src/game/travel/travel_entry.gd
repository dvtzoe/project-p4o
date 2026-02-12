extends Button

class_name TravelEntry

@export var label: Label

func setup(entry_name: String, on_press: Callable) -> void:
    label.text = entry_name
    pressed.connect(on_press)
