extends Control

class_name UnitStatus

@export var name_label: Label
@export var actions_container: HBoxContainer

func show_info(unit: Node2D) -> void:
    name_label.text = unit.get("type_name")

    var action_card_scene := preload("res://src/game/stage/unit_status/action_card.tscn")
    for action: Action in unit.get_node("Actions").get_children():
        var action_card_instance := action_card_scene.instantiate()
        action_card_instance.call("setup", action)
        actions_container.add_child(action_card_instance)
