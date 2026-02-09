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
        # Level up
        points -= points_to_next
        level += 1
        points_to_next = _points_to_next_level()