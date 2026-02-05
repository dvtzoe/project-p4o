extends "res://src/game/stage/units/pieces/piece.gd"

func compute_reachable_tiles() -> void:
    reachable_tiles.clear()
    var adjacent_hexes = HexUtils.get_adjacent_hex(coord)
    for hex in adjacent_hexes:
        if hex in StageState.instance.unit_at:
            continue
        reachable_tiles[hex] = 1

func _ready() -> void:
    type_name = "Pawn"
