extends Button

class_name SpawnButton

var unit_scene: PackedScene

func setup(unit_scene_in: PackedScene) -> void:
    unit_scene = unit_scene_in

func _pressed() -> void:
    if Game.stage.spawner.selected_unit_scene == unit_scene:
        Game.stage.spawner.deselect_spawning_unit()
    else:
        Game.stage.spawner.select_spawning_unit(unit_scene)
