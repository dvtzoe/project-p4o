extends Resource

class_name Datable

const ILLUSTS: Dictionary[String, Texture2D] = {
    "aiko": preload("res://assets/datables/aiko.png"),
}

@export var name: String
@export var id: String = ""

var level: int = 0
var points: int = 0

func _points_to_next_level() -> int:
    return 100 + level * 100

func add_points(amount: int) -> void:
    points += amount
    var points_to_next = _points_to_next_level()
    while points >= points_to_next:
        points -= points_to_next
        level += 1
        points_to_next = _points_to_next_level()

func to_dict() -> Dictionary:
    return {
        "id": id,
        "name": name,
        "level": level,
        "points": points,
    }

static func from_dict(d: Dictionary) -> Datable:
    var datable := Datable.new()
    datable.id = d.get("id", "")
    datable.name = d.get("name", "")
    datable.level = int(d.get("level", 0))
    datable.points = int(d.get("points", 0))
    return datable
