extends Sprite2D

class_name StorySprite

var size_y: float

var position_x: float
var position_y: float

func _on_viewport_size_changed() -> void:
    if not get_viewport():
        return
    var viewport_size = get_viewport().size
    scale.x = (float(viewport_size.y) * size_y / texture.get_height())
    scale.y = (float(viewport_size.y) * size_y / texture.get_height())
    position.x = viewport_size.x * position_x
    position.y = viewport_size.y * position_y