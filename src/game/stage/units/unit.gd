extends Node2D

class_name Unit

enum Team {
    PLAYER,
    ENEMY,
    NEUTRAL,
}

signal unit_died(unit: Unit)

@export var unit_name: String

var actions: Array[Action] = []
var health: Health
var movement: Movement

var team: Team
var coord: Vector2i

var is_dying: bool = false

func _ready() -> void:
    if has_node("Movement"):
        movement = get_node("Movement") as Movement
    if has_node("Health"):
        health = get_node("Health") as Health
    for action: Action in get_node("Actions").get_children():
        actions.append(action)

func die() -> void:
    is_dying = true
    unit_died.emit(self )
    Game.stage.unit.at.erase(coord)
    queue_free()

func on_turn_end() -> void:
    if movement:
        movement.available_movement = movement.movement_per_turn
        movement.compute_reachable_tiles()
    for action in actions:
        action.on_turn_end()
