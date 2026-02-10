extends Node

class_name Stage

@export var overlays_layer: Node2D
@export var units_layer: Node2D
@export var canvas_layer: CanvasLayer

@export var state: StageState
@export var unit: StageUnit
@export var spawner: StageSpawner

@export var end_turn_button: Button
@export var end_preparation_button: Button

var map: TileMapLayer

func start(data: StageResource) -> void:
    spawner.setup()
    if data.map:
        map = data.map.instantiate() as TileMapLayer
        add_child(map)
    if data.waves.size() > 0:
        for i in range(data.waves.size()):
            var wave = data.waves[i]
            state.current_wave = i
            for unit_entry: SpawnEntry in wave.spawn:
                unit.spawn(unit_entry.unit_type, unit_entry.coord, unit_entry.team)
            if wave.hooks.size() > 0:
                for hook in wave.hooks:
                    if hook is StoryHook:
                        var story_scene = preload("res://src/game/story/story.tscn")
                        var story_instance = story_scene.instantiate()
                        canvas_layer.add_child(story_instance)
                        var story_data = hook.story
                        await story_instance.load_story(story_data)
                        story_instance.queue_free()
                    else:
                        print("Unknown hook type: %s" % hook.type)

func _input(event: InputEvent) -> void:
    if state.is_selecting_tile and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
        state.deselect_tile()
        spawner.selected_unit_scene = null

func _on_end_turn_button_pressed() -> void:
    state.end_player_turn()

func _on_end_preparation_button_pressed() -> void:
    state.state = "playing"
    spawner.close()
    end_preparation_button.visible = false
    end_turn_button.visible = true
