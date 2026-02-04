extends "res://src/game/stage/units/pieces/piece.gd"

func can_move_to(to_coord: Vector2i) -> bool:
    # check if target is adjacent
    var adjacent_hexes = HexUtils.get_adjacent_hex(coord)
    print(to_coord, adjacent_hexes)
    if to_coord not in adjacent_hexes:
        return false
    return true
