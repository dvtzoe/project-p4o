extends TileMapLayer

func _unhandled_input(event):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        var cell = local_to_map(to_local(get_global_mouse_position()))
        if Game.stage.state.is_selecting_tile and Game.stage.unit.at.has(Game.stage.state.selected_tile):
            var selected_unit = Game.stage.unit.at[Game.stage.state.selected_tile]
            if not selected_unit.team == Unit.Team.PLAYER:
                Game.stage.state.deselect_tile()
                return

            if selected_unit.movement and selected_unit.movement.available_movement > 0 and selected_unit.movement.reachable_tiles.has(cell):
                Game.stage.unit.move_to(selected_unit, cell)
                selected_unit.movement.available_movement -= 1
                Game.stage.state.deselect_tile()
                return
            if Game.stage.state.selected_action and Game.stage.state.selected_action.actionable_tiles.has(cell):
                var action_node = Game.stage.state.selected_action
                action_node.perform(cell)
            Game.stage.state.deselect_tile()
            return
        Game.stage.state.select_tile(cell)
