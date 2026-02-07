extends Node2D

class_name Unit

@export var unit_name: String

@onready var movement: Movement = get_node("Movement")
@onready var health: Health = get_node("Health")
@onready var actions: Array[Action] = []


var team: String
var coord: Vector2i

func _ready() -> void:
    for action: Action in get_node("Actions").get_children():
        actions.append(action)