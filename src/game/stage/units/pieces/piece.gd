extends "res://src/game/stage/units/unit.gd"


func can_move_to(_to_coord: Vector2i) -> bool:
    push_error("Piece can_move_to() not implemented yet.")
    return false

func _ready() -> void:
    type_name = "Piece"