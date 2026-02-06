extends Node

class_name Action

@onready var unit: Unit = get_parent().get_parent()

# abstract
var action_type: String

# abstract
func perform(_target: Vector2i) -> void:
    pass

# abstract
func compute_actionable_tiles() -> void:
    pass
