extends Node

class_name Action

signal action_performed

@export var action_per_turn: int = 1

@onready var unit: Unit = get_parent().get_parent()

var actionable_tiles: Array[Vector2i] = []
var action_reachable_tiles: Array[Vector2i] = []

var available_uses: int = action_per_turn

# abstract
func perform(_target: Vector2i) -> void:
    push_error("perform() not implemented in subclass of Action")
    emit_signal("action_performed")

# abstract
func compute_actionable_tiles() -> void:
    push_error("compute_actionable_tiles() not implemented in subclass of Action")

func on_turn_end() -> void:
    available_uses = action_per_turn