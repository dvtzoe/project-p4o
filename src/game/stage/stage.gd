extends Control

var units_id: Array[int] = []

var max_id: int = 0

func spawn_unit(unit_type: String, coordinate: Vector2i) -> void:
    var unit_scene: PackedScene = load("res://src/game/stage/units/%s.tscn" % unit_type)
    var unit_instance: Node2D = unit_scene.instantiate()
    unit_instance.position = PositionAdapter.tile_to_px(coordinate)
    unit_instance.set("unit_type", unit_type)
    unit_instance.set("id", max_id)
    unit_instance.set("coordinate", coordinate)
    max_id += 1
    add_child(unit_instance)
    units_id.append(max_id)
