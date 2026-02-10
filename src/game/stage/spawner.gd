extends PanelContainer

class_name StageSpawner

const SPAWN_BUTTON_SCENE := preload("res://src/game/stage/spawn_button.tscn")

const UNIT_SCENES = {
    "pawn": preload("res://src/game/stage/units/pieces/pawn.tscn"),
}

@export var spawn_buttons_container: VBoxContainer

var selected_unit_scene: PackedScene

var unit_preview_instance: Node2D

func select_spawning_unit(unit_scene: PackedScene) -> void:
    selected_unit_scene = unit_scene
    if unit_preview_instance:
        unit_preview_instance.queue_free()
    unit_preview_instance = unit_scene.instantiate() as Node2D
    unit_preview_instance.modulate = Color(1, 1, 1, 0.5)
    unit_preview_instance.visible = false
    Game.stage.units_layer.add_child(unit_preview_instance)

func deselect_spawning_unit() -> void:
    selected_unit_scene = null
    if unit_preview_instance:
        unit_preview_instance.queue_free()
        unit_preview_instance = null

func open() -> void:
    visible = true

func close() -> void:
    visible = false

func setup() -> void:
    for unit_type in UNIT_SCENES.keys():
        var spawn_button = SPAWN_BUTTON_SCENE.instantiate() as SpawnButton
        spawn_button.text = unit_type
        spawn_button.setup(UNIT_SCENES[unit_type])
        spawn_buttons_container.add_child(spawn_button)
