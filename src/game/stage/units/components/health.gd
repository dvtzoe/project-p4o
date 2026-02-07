extends Node

class_name Health

@export var max_health: int

@onready var unit: Unit = get_parent() as Unit

var current_health: int

func hurt(amount: int) -> void:
    current_health = current_health - amount
    if current_health <= 0:
        unit.die()
        Game.stage.recompute_units_tiles()

func _ready() -> void:
    current_health = max_health