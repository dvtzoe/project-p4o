extends "res://src/game/stage/units/unit.gd"

var reachable_tiles: Dictionary[Vector2i, int] = {}

# abstract
func compute_reachable_tiles() -> void:
    push_error("compute_reachable_tiles() not implemented yet.")

func _ready() -> void:
    type_name = "Piece"
