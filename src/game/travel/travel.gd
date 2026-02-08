extends Control

class_name Travel

@export var TravelEntryContainer: VBoxContainer

func _on_explore_pressed() -> void:
    Game.change_state(Game.State.STAGE)
    queue_free()

func _ready() -> void:
    var travel_entry_scene = preload("res://src/game/travel/travel_entry.tscn")
    
    var explore_entry: TravelEntry = travel_entry_scene.instantiate()
    explore_entry.setup("Explore")
    explore_entry.connect("pressed", Callable(self , "_on_explore_pressed"))
    TravelEntryContainer.add_child(explore_entry)
