extends "res://src/game/stage/units/unit.gd"

signal move(from_coords: Vector2i, to_coord: Vector2i)

func can_move_to(_to_coord: Vector2i) -> bool:
    push_error("Piece can_move_to() not implemented yet.")
    return false

func move_to(to_coord: Vector2i) -> void:
    if not can_move_to(to_coord):
        return
    emit_signal("move", coord, to_coord)
    coord = to_coord
    position = PositionAdapter.tile_to_px(coord)
