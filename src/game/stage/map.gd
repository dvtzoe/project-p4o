extends TileMapLayer

class_name StageMap

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        var cell = local_to_map(to_local(get_global_mouse_position()))
        if Game.stage.state.state == "playing":
            if Game.stage.state.is_selecting_tile and Game.stage.unit.at.has(Game.stage.state.selected_tile):
                var selected_unit = Game.stage.unit.at[Game.stage.state.selected_tile]
                if not selected_unit.team == Unit.Team.PLAYER:
                    Game.stage.state.deselect_tile()
                    return

                if selected_unit.movement and selected_unit.movement.available_movement > 0 and selected_unit.movement.reachable_tiles.has(cell):
                    selected_unit.movement.head_to(cell)
                    selected_unit.movement.available_movement -= 1
                    Game.stage.state.deselect_tile()
                    return

                if Game.stage.state.selected_action and Game.stage.state.selected_action.actionable_tiles.has(cell):
                    var action_node = Game.stage.state.selected_action
                    action_node.perform(cell)
                    Game.stage.state.deselect_tile()
                    return
                    
                Game.stage.state.deselect_tile()
            else:
                Game.stage.state.select_tile(cell)
                return
        if Game.stage.spawner.selected_unit_scene:
            Game.stage.unit.spawn(Game.stage.spawner.selected_unit_scene, cell, Unit.Team.PLAYER)
            return
    elif event is InputEventMouseMotion:
        var cell = local_to_map(to_local(get_global_mouse_position()))
        if Game.stage.spawner.selected_unit_scene:
            Game.stage.spawner.unit_preview_instance.visible = true
            Game.stage.spawner.unit_preview_instance.position = HexUtils.tile_to_px(cell)
