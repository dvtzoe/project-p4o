extends Node

class_name StageUnit

var at: Dictionary[Vector2i, Unit] = {}

func recompute_tiles() -> void:
    for unit: Unit in at.values():
        if unit.movement:
            unit.movement.compute_reachable_tiles()
        if unit.actions:
            for action in unit.actions:
                action.compute_actionable_tiles()

func spawn(type: String, coord: Vector2i, team: String) -> void:
    var unit_scene: PackedScene = load(Constants.UNITS_TABLE[type])
    var unit_instance: Unit = unit_scene.instantiate()
    unit_instance.position = HexUtils.tile_to_px(coord)
    
    unit_instance.coord = coord
    unit_instance.team = team

    at[coord] = unit_instance
    
    recompute_tiles()
    Game.stage.units_layer.add_child(unit_instance)


func move_to(unit: Unit, target_tile: Vector2i) -> void:
    at.erase(unit.coord)
    unit.position = HexUtils.tile_to_px(target_tile)
    unit.coord = target_tile
    at[target_tile] = unit
    recompute_tiles()