extends "res://src/game/stage/units/pieces/piece.gd"

func move_to(target: Vector2i) -> void:
    # check if target is adjacent
    var dx = target.x - coordinate.x
    var dy = target.y - coordinate.y
    if coordinate.y % 2 == 0:
        if not ((dx == 0 and abs(dy) == 1) or (dx == -1 and dy == 0) or (dx == 1 and dy == 0) or (dx == -1 and dy == -1) or (dx == 0 and dy == -1) or (dx == -1 and dy == 1)):
            push_error("Pawn can only move to adjacent tiles.")
            return
    else:
        if not ((dx == 0 and abs(dy) == 1) or (dx == -1 and dy == 0) or (dx == 1 and dy == 0) or (dx == 0 and dy == -1) or (dx == 1 and dy == -1) or (dx == 0 and dy == 1)):
            push_error("Pawn can only move to adjacent tiles.")
            return
    # move to target
    coordinate = target
    position = PositionAdapter.tile_to_px(coordinate)
