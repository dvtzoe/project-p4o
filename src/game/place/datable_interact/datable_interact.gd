extends Node

class_name DatableInteract

const CHOICE_BUTTON_SCENE := preload("res://src/ui/choice_button.tscn")

const SIZE_Y := 1
const POSITION_X := 0.25
const POSITION_Y := 0.67

@export var datable_sprite: Sprite2D
@export var interactions_container: VBoxContainer

var datable: Datable

func on_nevermind_button_pressed() -> void:
    queue_free()
    Game.place.uninteract_datable()

func on_viewport_size_changed() -> void:
    var texture = Datable.ILLUSTS.get(datable.id, null)
    var viewport_size = get_viewport().size
    var new_scale = (float(viewport_size.y) * SIZE_Y / texture.get_height())
    datable_sprite.scale.x = new_scale
    datable_sprite.scale.y = new_scale
    datable_sprite.position.x = viewport_size.x * POSITION_X
    datable_sprite.position.y = viewport_size.y * POSITION_Y

func setup(datable_in: Datable) -> void:
    datable = datable_in
    datable_sprite.texture = Datable.ILLUSTS.get(datable.id, null)
    if datable_sprite.texture == null:
        push_error("No illustration found for datable ID: %s" % datable.id)
        return

    var nevermind_button = CHOICE_BUTTON_SCENE.instantiate() as Button
    nevermind_button.text = "Nevermind"
    nevermind_button.pressed.connect(on_nevermind_button_pressed)
    interactions_container.add_child(nevermind_button)

    on_viewport_size_changed()
