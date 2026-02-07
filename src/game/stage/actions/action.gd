extends Node

class_name Action

@export var action_type: Enums.ActionType

@onready var unit: Unit = get_parent().get_parent()

var actionable_tiles: Array[Vector2i] = []
var action_reachable_tiles: Array[Vector2i] = []

# abstract
func perform(_target: Vector2i) -> void:
    push_error("perform() not implemented in subclass of Action")

# abstract
func compute_actionable_tiles() -> void:
    push_error("compute_actionable_tiles() not implemented in subclass of Action")
