extends Node

class_name Movement

@export var movement_points: int

@onready var unit: Unit = get_parent()

var reachable_tiles: Array[Vector2i] = []

func compute_reachable_tiles() -> void:
    reachable_tiles.clear()
    var frontier_positions: Array[Vector2i] = [unit.coord]
    var frontier_costs: Array[int] = [0]
    
    while frontier_positions.size() > 0:
        var current_pos: Vector2i = frontier_positions.pop_front()
        var current_cost: int = frontier_costs.pop_front()
        
        if current_pos in reachable_tiles:
            continue
        
        if current_pos != unit.coord:
            reachable_tiles.append(current_pos)
        
        if current_cost >= movement_points:
            continue
        
        var neighbors: Array[Vector2i] = HexUtils.get_adjacent_hex(current_pos)
        for neighbor in neighbors:
            if Game.stage.unit.at.has(neighbor):
                continue
            if Game.stage.tile_map_layer.get_cell_source_id(neighbor) == -1:
                continue
            
            frontier_positions.append(neighbor)
            frontier_costs.append(current_cost + Constants.TILES[Game.stage.tile_map_layer.get_cell_source_id(neighbor)]["movement_cost"])
