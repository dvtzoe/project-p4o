extends Piece

class_name Pawn

@export var max_health: int = 100
@export var movement_points: int = 3

var reachable_tiles: Dictionary[Vector2i, int] = {}

func compute_reachable_tiles() -> void:
    reachable_tiles.clear()
    reachable_tiles = Movements.dijkstra_reachable_tiles(self )


func _ready() -> void:
    health = max_health
    compute_reachable_tiles()
