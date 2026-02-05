class_name Constants

const UNITS_TABLE = {
    "base": "res://src/game/stage/units/structures/base.tscn",
    "pawn": "res://src/game/stage/units/pieces/pawn.tscn",
}

var tiles: Dictionary

func _init() -> void:
    var file = FileAccess.open("res://src/game/stage/tiles.json", FileAccess.READ)
    if file:
        var json_content: String = file.get_as_text()
        tiles = JSON.parse_string(json_content).result
    file.close()
