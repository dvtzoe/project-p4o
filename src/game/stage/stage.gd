extends Node

var units_table: Dictionary[int, Node2D] = {}
var units_id: Array[int] = []
var unit_at: Dictionary[Vector2i, int] = {}

var current_wave: int = 0
var max_id: int = 0

func spawn_unit(type: String, coordinate: Vector2i) -> void:
    var unit_scene: PackedScene = load(Constants.UNITS_TABLE[type])
    var unit_instance: Node2D = unit_scene.instantiate()
    unit_instance.position = PositionAdapter.tile_to_px(coordinate)
    
    unit_instance.set("type", type)
    unit_instance.set("id", max_id)
    unit_instance.set("coordinate", coordinate)

    units_table[max_id] = unit_instance
    units_id.append(max_id)
    unit_at[coordinate] = max_id

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