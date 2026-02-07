class_name StageState

var is_selecting_tile: bool = false
var selected_tile: Vector2i

var selected_action: Action

var current_wave: int = 0

func select_tile(tile: Vector2i) -> void:
    is_selecting_tile = true
    selected_tile = tile
    if Game.stage.unit.at.has(tile):
        var unit_status_scene = preload("res://src/game/stage/unit_status/unit_status.tscn")
        var unit_status_instance = unit_status_scene.instantiate()
        unit_status_instance.call("show_info", Game.stage.unit.at[tile])
        Game.stage.canvas_layer.add_child(unit_status_instance)

        if Game.stage.unit.at[tile].team == "player":
            if Game.stage.unit.at[tile].movement:
                for reachable_tile in Game.stage.unit.at[tile].movement.reachable_tiles:
                    Overlay.add(reachable_tile, Enums.OverlayState.MOVE_REACHABLE)
            if selected_action:
                for action_reachable_tile in selected_action.action_reachable_tiles:
                    Overlay.add(action_reachable_tile, Enums.OverlayState.ACTION_REACHABLE)
                for actionable_tile in selected_action.actionable_tiles:
                    Overlay.add(actionable_tile, Enums.OverlayState.ATTACKABLE)

        if Game.stage.unit.at[tile].team == "player":
            Overlay.add(tile, Enums.OverlayState.PLAYER_UNIT)
        else:
            Overlay.add(tile, Enums.OverlayState.ENEMY_UNIT)

func deselect_tile() -> void:
    if Game.stage.canvas_layer.has_node("UnitStatus"):
        Game.stage.canvas_layer.get_node("UnitStatus").queue_free()

    Overlay.remove_all()

    is_selecting_tile = false
    deselect_action()

func deselect_action() -> void:
    if not selected_action:
        return
    for cell in selected_action.action_reachable_tiles:
        Overlay.remove(cell, Enums.OverlayState.ACTION_REACHABLE)
    selected_action = null