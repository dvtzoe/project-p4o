class_name PositionAdapter

const TILE_SIZE := Vector2i(110, 128)

static func tile_to_px(coordinate: Vector2i) -> Vector2:
    if coordinate.y % 2 == 0:
        return Vector2(coordinate.x * TILE_SIZE.x, coordinate.y * TILE_SIZE.y * 3.0 / 4)
    else:
        return Vector2(coordinate.x * TILE_SIZE.x + TILE_SIZE.x / 2.0, coordinate.y * TILE_SIZE.y * 3.0 / 4)
