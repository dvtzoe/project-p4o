extends Control

class_name UnitStatus

@export var name_label: Label
@export var actions_container: HBoxContainer

func show_info(unit: Unit) -> void:
    name_label.text = unit.unit_name

    var action_card_scene := preload("res://src/game/stage/unit_status/action_card.tscn")
    for action: Action in unit.actions:
        var action_card_instance := action_card_scene.instantiate()
        action_card_instance.call("setup", action)
        actions_container.add_child(action_card_instance)
