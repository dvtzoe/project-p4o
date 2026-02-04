extends TileMapLayer

signal tile_clicked(cell: Vector2i)

func _unhandled_input(event):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        var cell = local_to_map(to_local(get_global_mouse_position()))
        emit_signal("tile_clicked", cell)
