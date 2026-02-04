extends "res://src/game/stage/units/pieces/piece.gd"

func can_move_to(to_coord: Vector2i) -> bool:
    # check if target is adjacent
    var dx = to_coord.x - coord.x
    var dy = to_coord.y - coord.y
    if coord.y % 2 == 0:
        if not ((dx == 0 and abs(dy) == 1) or (dx == -1 and dy == 0) or (dx == 1 and dy == 0) or (dx == -1 and dy == -1) or (dx == 0 and dy == -1) or (dx == -1 and dy == 1)):
            return false
    else:
        if not ((dx == 0 and abs(dy) == 1) or (dx == -1 and dy == 0) or (dx == 1 and dy == 0) or (dx == 0 and dy == -1) or (dx == 1 and dy == -1) or (dx == 0 and dy == 1)):
            return false
    return true
