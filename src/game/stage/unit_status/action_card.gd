extends PanelContainer

class_name ActionCard

@export var action_name_label: Label

var action: Action

func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        if action.unit.team != Unit.Team.PLAYER:
            return
        if Game.stage.state.selected_action == action:
            Game.stage.state.selected_action = null
            for tile in action.action_reachable_tiles:
                Overlay.remove(tile, Enums.OverlayState.ACTION_REACHABLE)
            for tile in action.actionable_tiles:
                Overlay.remove(tile, Enums.OverlayState.ATTACKABLE)
        else:
            Game.stage.state.selected_action = action
            for tile in action.action_reachable_tiles:
                Overlay.add(tile, Enums.OverlayState.ACTION_REACHABLE)
            for tile in action.actionable_tiles:
                Overlay.add(tile, Enums.OverlayState.ATTACKABLE)
        

func setup(action_node: Action) -> void:
    action = action_node
    action_name_label.text = action.action_name
