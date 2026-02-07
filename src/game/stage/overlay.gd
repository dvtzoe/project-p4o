extends Sprite2D

class_name Overlay

enum OverlayShape {
    HIGHLIGHT,
    DOT,
}


const COLORS = {
    Enums.OverlayState.MOVE_REACHABLE: Color(0, 0, 0, 0.25),
    Enums.OverlayState.ACTION_REACHABLE: Color(1, 0, 0, 0.25),
    Enums.OverlayState.ATTACKABLE: Color(1, 0, 0, 0.5),
    Enums.OverlayState.PLAYER_UNIT: Color(0, 0.5, 1, 0.5),
    Enums.OverlayState.ENEMY_UNIT: Color(1, 0, 0, 0.5),
}

const SHAPES = {
    Enums.OverlayState.MOVE_REACHABLE: OverlayShape.DOT,
    Enums.OverlayState.ACTION_REACHABLE: OverlayShape.DOT,
    Enums.OverlayState.ATTACKABLE: OverlayShape.HIGHLIGHT,
    Enums.OverlayState.PLAYER_UNIT: OverlayShape.HIGHLIGHT,
    Enums.OverlayState.ENEMY_UNIT: OverlayShape.HIGHLIGHT,
}

static var instances: Dictionary[Vector2i, Overlay] = {}

static func add(coord: Vector2i, state: Enums.OverlayState) -> void:
    if instances.has(coord):
        instances[coord].push_state(state)
    else:
        var overlay_scene = preload("res://src/game/stage/overlay.tscn")
        var overlay_instance = overlay_scene.instantiate()
        overlay_instance.position = HexUtils.tile_to_px(coord)
        instances[coord] = overlay_instance
        overlay_instance.push_state(state)
        Game.stage.overlays_layer.add_child(overlay_instance)

static func remove(coord: Vector2i, state: Enums.OverlayState) -> void:
    if instances.has(coord):
        instances[coord].erase_state(state)
        if instances[coord].state_queue.size() == 0:
            instances.erase(coord)

static func remove_all() -> void:
    for coord in instances.keys():
        instances[coord].queue_free()
    instances.clear()

@export var highlight_texture: Texture2D
@export var dot_texture: Texture2D

var state_queue: Array[Enums.OverlayState] = []

func push_state(new_state: Enums.OverlayState) -> void:
    state_queue.append(new_state)
    self_modulate = COLORS[state_queue[-1]]
    match SHAPES[state_queue[-1]]:
        OverlayShape.HIGHLIGHT:
            texture = highlight_texture
        OverlayShape.DOT:
            texture = dot_texture

func erase_state(state_to_remove: Enums.OverlayState) -> void:
    state_queue.erase(state_to_remove)
    if state_queue.size() > 0:
        self_modulate = COLORS[state_queue[-1]]
        match SHAPES[state_queue[-1]]:
            OverlayShape.HIGHLIGHT:
                texture = highlight_texture
            OverlayShape.DOT:
                texture = dot_texture
    else:
        queue_free()
