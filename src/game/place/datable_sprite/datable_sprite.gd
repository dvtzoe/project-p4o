extends Sprite2D

class_name DatableSprite

const SIZE_Y := 0.335
const POSITION_Y := 0.67

func on_viewport_size_changed() -> void:
    var viewport_size = get_viewport().size
    var texture_width = texture.get_width()
    var texture_height = texture.get_height()
    scale.x = (viewport_size.y * SIZE_Y * (float(texture_width) / texture_height)) / texture_width
    scale.y = viewport_size.y * SIZE_Y / texture_height
    position.y = viewport_size.y * POSITION_Y

func setup(datable: Datable) -> void:
    texture = Datable.ILLUSTS.get(datable.id, null)
    if texture == null:
        push_error("No illustration found for datable ID: %s" % datable.id)
        return
