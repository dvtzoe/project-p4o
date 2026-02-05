class_name StageState

static var instance: StageState

var is_selecting_tile: bool = false
var selected_tile: Vector2i

var unit_at: Dictionary[Vector2i, Node2D] = {}

var current_wave: int = 0

var tile_map_layer: TileMapLayer

func _init() -> void:
    instance = self