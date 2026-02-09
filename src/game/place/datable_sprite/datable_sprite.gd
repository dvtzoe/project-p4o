extends Area2D

class_name DatableSprite

const SIZE_Y := 0.335
const POSITION_Y := 0.67

@export var sprite: Sprite2D
@export var collision_shape: CollisionShape2D

var datable: Datable

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        Game.place.interact_datable(datable)

func on_viewport_size_changed() -> void:
    var viewport_size = get_viewport().size
    var texture_width = sprite.texture.get_width()
    var texture_height = sprite.texture.get_height()
    sprite.scale.x = (viewport_size.y * SIZE_Y * (float(texture_width) / texture_height)) / texture_width
    sprite.scale.y = viewport_size.y * SIZE_Y / texture_height

    collision_shape.shape.size.x = texture_width * sprite.scale.x
    collision_shape.shape.size.y = texture_height * sprite.scale.y
    
    position.y = viewport_size.y * POSITION_Y
    

func setup(datable_in: Datable) -> void:
    datable = datable_in
    var texture = Datable.ILLUSTS.get(datable.id, null)
    if texture == null:
        push_error("No illustration found for datable ID: %s" % datable.id)
        return
    sprite.texture = texture
    on_viewport_size_changed()
