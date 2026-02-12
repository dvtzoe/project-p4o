extends Control

class_name Travel

const TRAVEL_ENTRY_SCENE := preload("res://src/game/travel/travel_entry.tscn")

@export var travel_entry_container: VBoxContainer

func _on_explore_pressed() -> void:
    Game.change_state(Game.States.EXPLORE)
    queue_free()

func _ready() -> void:
    var explore_entry := TRAVEL_ENTRY_SCENE.instantiate() as TravelEntry
    explore_entry.setup("Explore", _on_explore_pressed)
    travel_entry_container.add_child(explore_entry)

func _on_back_button_pressed() -> void:
    Game.change_state(Game.States.PLACE)
    queue_free()
