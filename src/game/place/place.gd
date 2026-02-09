extends Node

class_name Place

func _ready() -> void:
    var datable_sprite_scene = preload("res://src/game/place/datable_sprite/datable_sprite.tscn")
    var datable_sprite = datable_sprite_scene.instantiate() as DatableSprite
    var aiko = Datable.new()
    aiko.id = "aiko"
    aiko.name = "Aiko"
    datable_sprite.setup(aiko)
    add_child(datable_sprite)

    var viewport = get_viewport()
    viewport.size_changed.connect(datable_sprite.on_viewport_size_changed)
    datable_sprite.on_viewport_size_changed()
    datable_sprite.position = Vector2i(viewport.size.x / 2, viewport.size.y * 0.67)

    var notification_data = NotificationData.new()
    notification_data.title = "Welcome"
    notification_data.message = "You have entered the place with %s." % aiko.name
    Notification.notify(notification_data)
