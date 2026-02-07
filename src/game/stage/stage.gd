extends Node

class_name Stage

@export var overlays_layer: Node2D
@export var units_layer: Node2D
@export var canvas_layer: CanvasLayer
@export var tile_map_layer: TileMapLayer

var state: StageState = StageState.new()

func _recompute_all_units_tiles() -> void:
    for unit: Unit in state.unit_at.values():
        if unit.movement:
            unit.movement.compute_reachable_tiles()
        if unit.actions:
            for action in unit.actions:
                action.compute_actionable_tiles()

func spawn_unit(type: String, coord: Vector2i, team: String) -> void:
    var unit_scene: PackedScene = load(Constants.UNITS_TABLE[type])
    var unit_instance: Unit = unit_scene.instantiate()
    unit_instance.position = HexUtils.tile_to_px(coord)
    
    unit_instance.coord = coord
    unit_instance.team = team

    state.unit_at[coord] = unit_instance
    
    _recompute_all_units_tiles()
    units_layer.add_child(unit_instance)

func _ready() -> void:
    var file = FileAccess.open("res://assets/stage/days/%d/default.json" % SaveManager.current_save.day, FileAccess.READ)
    if file:
        var json_content: String = file.get_as_text()
        var stage_data = JSON.parse_string(json_content)
        if stage_data.has("waves"):
            for i in range(stage_data["waves"].size()):
                var wave = stage_data["waves"][i]
                state.current_wave = i
                for unit_entry in wave["spawn"]:
                    var unit_type: String = unit_entry["type"]
                    var unit_coord_array: Array = unit_entry["coordinate"]
                    var unit_team: String = unit_entry["team"]
                    var unit_coordinate = Vector2i(unit_coord_array[0], unit_coord_array[1])
                    spawn_unit(unit_type, unit_coordinate, unit_team)
                if wave.has("hooks"):
                    for hook in wave["hooks"]:
                        match hook["type"]:
                            "story":
                                var story_scene = preload("res://src/game/story/story.tscn")
                                var story_instance = story_scene.instantiate()
                                canvas_layer.add_child(story_instance)
                                var story_data = hook["story"]
                                await story_instance.load_story(story_data)
                                story_instance.queue_free()
                            _:
                                print("Unknown hook type: %s" % hook["type"])
    file.close()


func _select_tile(tile: Vector2i) -> void:
    state.selected_tile = tile
    if state.unit_at.has(tile):
        var unit_status_scene = preload("res://src/game/stage/unit_status/unit_status.tscn")
        var unit_status_instance = unit_status_scene.instantiate()
        unit_status_instance.call("show_info", state.unit_at[tile])
        canvas_layer.add_child(unit_status_instance)

        if state.unit_at[tile].team == "player":
            if state.unit_at[tile].movement:
                for reachable_tile in state.unit_at[tile].movement.reachable_tiles:
                    Overlay.add(reachable_tile, Enums.OverlayState.MOVE_REACHABLE)
            if state.selected_action:
                for action_reachable_tile in state.selected_action.action_reachable_tiles:
                    Overlay.add(action_reachable_tile, Enums.OverlayState.ACTION_REACHABLE)
                for actionable_tile in state.selected_action.actionable_tiles:
                    Overlay.add(actionable_tile, Enums.OverlayState.ATTACKABLE)

        if state.unit_at[tile].team == "player":
            Overlay.add(tile, Enums.OverlayState.PLAYER_UNIT)
        else:
            Overlay.add(tile, Enums.OverlayState.ENEMY_UNIT)

func _deselect_tile() -> void:
    if canvas_layer.has_node("UnitStatus"):
        canvas_layer.get_node("UnitStatus").queue_free()

    Overlay.remove_all()

    state.is_selecting_tile = false

func _deselect_action() -> void:
    if not state.selected_action:
        return
    for cell in state.selected_action.action_reachable_tiles:
        Overlay.remove(cell, Enums.OverlayState.ACTION_REACHABLE)
    state.selected_action = null

func _move_unit_to(unit: Unit, target_tile: Vector2i) -> void:
    unit.position = HexUtils.tile_to_px(target_tile)
    unit.coord = target_tile
    state.unit_at[target_tile] = state.unit_at[state.selected_tile]
    state.unit_at.erase(state.selected_tile)
    unit.movement.compute_reachable_tiles()
    if unit.actions:
        for action in unit.actions:
            action.compute_actionable_tiles()

func _on_tile_map_layer_tile_clicked(cell: Vector2i) -> void:
    if state.selected_tile and state.unit_at.has(state.selected_tile):
        var unit = state.unit_at[state.selected_tile]
        if not unit.team == "player":
            _deselect_tile()
            return

        if unit.movement and unit.movement.reachable_tiles.has(cell):
            _move_unit_to(unit, cell)
            _deselect_tile()
            return
        if state.selected_action and state.selected_action.actionable_tiles.has(cell):
            var action_node = state.selected_action
            action_node.perform(cell)
        _deselect_tile()
        _deselect_action()
        return
    _select_tile(cell)

func _input(event: InputEvent) -> void:
    if state.is_selecting_tile and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
        _deselect_tile()
