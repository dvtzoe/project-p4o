extends Node

@export var highlight: Sprite2D
@export var canvas_layer: CanvasLayer
@export var tile_map_layer: TileMapLayer

var state: StageState = StageState.new()

var max_id: int = 0

func spawn_unit(type: String, coord: Vector2i, team: String) -> void:
    var unit_scene: PackedScene = load(Constants.UNITS_TABLE[type])
    var unit_instance: Node2D = unit_scene.instantiate()
    unit_instance.position = HexUtils.tile_to_px(coord)
    
    unit_instance.set("type", type)
    unit_instance.set("id", max_id)
    unit_instance.set("coord", coord)
    unit_instance.set("team", team)

    state.unit_at[coord] = unit_instance

    for unit in state.unit_at.values():
        if unit.has_method("compute_reachable_tiles"):
            unit.call("compute_reachable_tiles")
    max_id += 1
    add_child(unit_instance)

func _ready() -> void:
    state.tile_map_layer = tile_map_layer
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


func _select_tile(cell: Vector2i) -> void:
    state.is_selecting_tile = true
    state.selected_tile = cell
    if state.unit_at.has(cell):
        var unit_status_scene = preload("res://src/game/stage/unit_status.tscn")
        var unit_status_instance = unit_status_scene.instantiate()
        unit_status_instance.call("show_info", state.unit_at[cell])
        canvas_layer.add_child(unit_status_instance)

        if state.unit_at[cell].get("reachable_tiles") and state.unit_at[cell].get("team") == "player":
            var reachable_overlay_scene = preload("res://src/game/stage/reachable_overlay.tscn")
            for reachable_tile in state.unit_at[cell].get("reachable_tiles").keys():
                var overlay_instance = reachable_overlay_scene.instantiate()
                overlay_instance.position = HexUtils.tile_to_px(reachable_tile)
                add_child(overlay_instance)

        highlight.position = HexUtils.tile_to_px(cell)
        highlight.visible = true
        if state.unit_at[cell].get("team") == "player":
            highlight.self_modulate = Color(0, 0.5, 1, 0.5)
        else:
            highlight.self_modulate = Color(1, 0, 0, 0.5)

func _deselect_tile() -> void:
    if canvas_layer.has_node("UnitStatus"):
        canvas_layer.get_node("UnitStatus").queue_free()

    for child in get_children():
        if child.scene_file_path == "res://src/game/stage/reachable_overlay.tscn":
            child.queue_free()

    state.is_selecting_tile = false
    highlight.visible = false

func _on_tile_map_layer_tile_clicked(cell: Vector2i) -> void:
    if state.is_selecting_tile and state.unit_at.has(state.selected_tile):
        var unit = state.unit_at[state.selected_tile]
        if not unit.get("team") == "player":
            _deselect_tile()
            return

        if unit.get("reachable_tiles") and unit.get("reachable_tiles").has(cell):
            unit.position = HexUtils.tile_to_px(cell)
            unit.set("coord", cell)
            state.unit_at[cell] = state.unit_at[state.selected_tile]
            state.unit_at.erase(state.selected_tile)
            unit.call("compute_reachable_tiles")
        _deselect_tile()
        return
    _select_tile(cell)

func _input(event: InputEvent) -> void:
    if state.is_selecting_tile and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
        _deselect_tile()
