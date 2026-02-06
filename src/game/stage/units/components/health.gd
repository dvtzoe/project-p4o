extends Node

@export var max_health: int
var current_health: int

func hurt(amount: int) -> void:
    current_health = max(current_health - amount, 0)

func _ready() -> void:
    current_health = max_health