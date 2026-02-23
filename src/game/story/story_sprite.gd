extends Sprite2D

class_name StorySprite

var size_y: float = 0.67

func _on_viewport_size_changed() -> void:
    print(get_viewport().size.y)
    print(size_y)
    print(texture.get_height())
    scale.x = (float(get_viewport().size.y) * size_y / texture.get_height())
    scale.y = (float(get_viewport().size.y) * size_y / texture.get_height())