extends Node2D

class_name Unit

enum Team {
    PLAYER,
    ENEMY,
    NEUTRAL,
}

@export var unit_name: String

var actions: Array[Action] = []
var health: Health
var movement: Movement

var team: Team
var coord: Vector2i

func _ready() -> void:
    if has_node("Movement"):
        movement = get_node("Movement") as Movement
    if has_node("Health"):
        health = get_node("Health") as Health
    for action: Action in get_node("Actions").get_children():
        actions.append(action)

func die() -> void:
    Game.stage.unit.at.erase(coord)
    queue_free()