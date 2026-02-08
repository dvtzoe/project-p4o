extends Button

class_name TravelEntry

@export var label: Label

func setup(entry_name: String) -> void:
    label.text = entry_name
