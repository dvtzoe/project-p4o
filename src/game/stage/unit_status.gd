extends Control

@export var name_label: Label

func show_info(unit: Node2D) -> void:
    name_label.text = unit.get("type_name")
