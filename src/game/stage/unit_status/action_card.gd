extends PanelContainer

class_name ActionCard

@export var action_name_label: Label

var action: Action

func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        if Game.stage.state.selected_action == action:
            Game.stage.state.selected_action = null
            for cell in Game.stage.state.unit_at[Game.stage.state.selected_tile].action_reachable_tiles[action.name]:
                Overlay.remove(cell, Enums.OverlayState.ACTION_REACHABLE)
        else:
            Game.stage.state.selected_action = action
            for cell in Game.stage.state.unit_at[Game.stage.state.selected_tile].action_reachable_tiles[action.name]:
                Overlay.add(cell, Enums.OverlayState.ACTION_REACHABLE)
        

func setup(action_node: Action) -> void:
    action = action_node
    action_name_label.text = action.action_name
    action.compute_actionable_tiles()
