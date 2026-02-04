extends Node

@export var highlight: Sprite2D

var is_selecting_tile: bool = false
var selected_tile: Vector2i

var unit_at: Dictionary[Vector2i, Node2D] = {}

var current_wave: int = 0
var max_id: int = 0

func spawn_unit(type: String, coord: Vector2i) -> void:
    var unit_scene: PackedScene = load(Constants.UNITS_TABLE[type])
    var unit_instance: Node2D = unit_scene.instantiate()
    unit_instance.position = PositionAdapter.tile_to_px(coord)
    
    unit_instance.set("type", type)
    unit_instance.set("id", max_id)
    unit_instance.set("coord", coord)

    unit_at[coord] = unit_instance

    max_id += 1
    add_child(unit_instance)

func _ready() -> void:
    var file = FileAccess.open("res://assets/stage/days/%d/default.json" % SaveManager.current_save.day, FileAccess.READ)
    if file:
        var json_content: String = file.get_as_text()
        var stage_data = JSON.parse_string(json_content)
        if stage_data.has("waves"):
            for i in range(stage_data["waves"].size()):
                var wave = stage_data["waves"][i]
                current_wave = i
                for unit_entry in wave["spawn"]:
                    var unit_type: String = unit_entry["type"]
                    var unit_coord_array: Array = unit_entry["coordinate"]
                    var unit_coordinate = Vector2i(unit_coord_array[0], unit_coord_array[1])
                    spawn_unit(unit_type, unit_coordinate)
    file.close()


func _select_tile(cell: Vector2i) -> void:
    is_selecting_tile = true
    selected_tile = cell
    if unit_at.has(cell):
        highlight.position = PositionAdapter.tile_to_px(cell)
        highlight.visible = true
        highlight.self_modulate = Color(0, 0.5, 1, 0.5)

func _deselect_tile() -> void:
    is_selecting_tile = false
    highlight.visible = false

func _on_tile_map_layer_tile_clicked(cell: Vector2i) -> void:
    if is_selecting_tile and unit_at.has(selected_tile):
        var unit = unit_at[selected_tile]
        if unit.has_method("can_move_to"):
            var can_move_to = unit.call("can_move_to", cell)
            if can_move_to and not unit_at.has(cell):
                unit.position = PositionAdapter.tile_to_px(cell)
                unit.set("coord", cell)
                unit_at[cell] = unit_at[selected_tile]
                unit_at.erase(selected_tile)
        _deselect_tile()
        return
    _select_tile(cell)

func _input(event: InputEvent) -> void:
    if is_selecting_tile and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
        _deselect_tile()
