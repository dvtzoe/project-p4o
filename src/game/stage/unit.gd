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

func spawn(unit_scene: PackedScene, coord: Vector2i, team: Unit.Team) -> void:
    var unit_instance: Unit = unit_scene.instantiate()
    unit_instance.position = HexUtils.tile_to_px(coord)
    
    unit_instance.coord = coord
    unit_instance.team = team

    at[coord] = unit_instance
    
    recompute_tiles()
    Game.stage.units_layer.add_child(unit_instance)

func despawn(coord: Vector2i) -> void:
    if at.has(coord):
        var unit_instance: Unit = at[coord]
        unit_instance.die()
        recompute_tiles()