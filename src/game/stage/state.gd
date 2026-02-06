class_name StageState

var is_selecting_tile: bool = false
var selected_tile: Vector2i

var selected_action: Action

var unit_at: Dictionary[Vector2i, Unit] = {}

var current_wave: int = 0
