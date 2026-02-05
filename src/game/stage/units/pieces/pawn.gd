extends "res://src/game/stage/units/pieces/piece.gd"

func compute_reachable_tiles() -> void:
    reachable_tiles.clear()
    reachable_tiles = Movements.dijkstra_reachable_tiles(coord, 3)

func _ready() -> void:
    type_name = "Pawn"
