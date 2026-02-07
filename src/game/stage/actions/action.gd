extends Node

class_name Action

@export var action_type: Enums.ActionType

@onready var unit: Unit = get_parent().get_parent()

# abstract
func perform(_target: Vector2i) -> void:
    pass

# abstract
func compute_actionable_tiles() -> void:
    pass
