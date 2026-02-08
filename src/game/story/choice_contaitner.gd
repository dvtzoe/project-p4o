extends MarginContainer

var index: int

signal choice_made(index)

func _on_button_pressed() -> void:
    emit_signal("choice_made", index)