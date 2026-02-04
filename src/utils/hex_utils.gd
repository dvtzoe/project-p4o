class_name HexUtils

const TILE_SIZE := Vector2i(110, 128)

static func tile_to_px(coordinate: Vector2i) -> Vector2:
    if coordinate.y % 2 == 0:
        return Vector2(coordinate.x * TILE_SIZE.x + TILE_SIZE.x * 0.5, coordinate.y * TILE_SIZE.y * 0.75 + TILE_SIZE.y * 0.5)
    else:
        return Vector2(coordinate.x * TILE_SIZE.x + TILE_SIZE.x, coordinate.y * TILE_SIZE.y * 0.75 + TILE_SIZE.y * 0.5)

static func get_adjacent_hex(coord: Vector2i) -> Array[Vector2i]:
    if coord.y % 2 == 0:
        return [
            coord + Vector2i(1, 0), coord + Vector2i(0, 1), coord + Vector2i(-1, 1),
            coord + Vector2i(-1, 0), coord + Vector2i(-1, -1), coord + Vector2i(0, -1)
        ]
    else:
        return [
            coord + Vector2i(1, 0), coord + Vector2i(1, 1), coord + Vector2i(0, 1),
            coord + Vector2i(-1, 0), coord + Vector2i(0, -1), coord + Vector2i(1, -1)
        ]
