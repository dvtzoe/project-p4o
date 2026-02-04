extends Node2D

@export var unit_name: String
@export var max_health: int

var id: int
var hp: int
var grid_pos: Vector2i

func _ready():
    hp = max_health
