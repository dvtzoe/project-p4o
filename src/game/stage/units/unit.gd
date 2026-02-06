extends Node2D

class_name Unit

var type_name := "Unit"
var type: String
var id: int
var team: String
var coord: Vector2i
var health: int
var action_reachable_tiles: Dictionary[StringName, Array] = {}
var actionable_tiles: Dictionary[StringName, Array] = {}

func _enter_tree() -> void:
    for action in get_node("Actions").get_children():
        action_reachable_tiles[action.name] = []
        actionable_tiles[action.name] = []