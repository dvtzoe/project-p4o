extends Node

class_name Place

const DATABLE_SPRITE_SCENE := preload("res://src/game/place/datable_sprite/datable_sprite.tscn")
const DATABLE_INTERACT_SCENE := preload("res://src/game/place/datable_interact/datable_interact.tscn")

@export var hide_on_interact: Array[Node] = []
@export var datable_sprites_container: Node

func _ready() -> void:
    var datable_sprite = DATABLE_SPRITE_SCENE.instantiate() as DatableSprite
    var aiko = Datable.new()
    aiko.id = "aiko"
    aiko.name = "Aiko"
    datable_sprites_container.add_child(datable_sprite)
    datable_sprite.setup(aiko)

    var viewport = get_viewport()
    viewport.size_changed.connect(datable_sprite.on_viewport_size_changed)
    datable_sprite.on_viewport_size_changed()
    datable_sprite.position = Vector2i(viewport.size.x / 2, viewport.size.y * 0.67)

    var notification_data = NotificationData.new()
    notification_data.title = "Welcome"
    notification_data.message = "You have entered the place with %s." % aiko.name
    Notification.notify(notification_data)

func interact_datable(datable: Datable) -> void:
    for node in hide_on_interact:
        node.visible = false
    
    var datable_interact = DATABLE_INTERACT_SCENE.instantiate() as DatableInteract
    add_child(datable_interact)
    datable_interact.setup(datable)

func uninteract_datable() -> void:
    for node in hide_on_interact:
        node.visible = true
