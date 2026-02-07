extends Node

class_name Stage

@export var overlays_layer: Node2D
@export var units_layer: Node2D
@export var canvas_layer: CanvasLayer
@export var tile_map_layer: TileMapLayer

var state: StageState = StageState.new()
var unit: StageUnit = StageUnit.new()

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
                    unit.spawn(unit_entry["type"], Vector2i(unit_entry["coordinate"][0], unit_entry["coordinate"][1]), unit_entry["team"])
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


func _on_tile_map_layer_tile_clicked(cell: Vector2i) -> void:
    if state.is_selecting_tile and unit.at.has(state.selected_tile):
        var selected_unit = unit.at[state.selected_tile]
        if not selected_unit.team == "player":
            state.deselect_tile()
            return

        if selected_unit.movement and selected_unit.movement.reachable_tiles.has(cell):
            unit.move_to(selected_unit, cell)
            state.deselect_tile()
            return
        if state.selected_action and state.selected_action.actionable_tiles.has(cell):
            var action_node = state.selected_action
            action_node.perform(cell)
        state.deselect_tile()
        return
    state.select_tile(cell)

func _input(event: InputEvent) -> void:
    if state.is_selecting_tile and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
        state.deselect_tile()
