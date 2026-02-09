extends Node

class_name Movement

@export var movement_points: int
@export var movement_per_turn: int = 1

@onready var unit: Unit = get_parent()

var reachable_tiles: Array[Vector2i] = []

var available_movement: int = movement_per_turn

func is_blocked(tile: Vector2i) -> bool:
    if Game.stage.unit.at.has(tile):
        return true
    if Game.stage.map.get_cell_source_id(tile) == -1:
        return true
    return false

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
            if Game.stage.map.get_cell_source_id(neighbor) == -1:
                continue
            
            frontier_positions.append(neighbor)
            frontier_costs.append(current_cost + Constants.TILES[Game.stage.map.get_cell_source_id(neighbor)]["movement_cost"])

func head_to(target_tile: Vector2i) -> void:
    var frontier := []
    frontier.push_back(unit.coord)

    var came_from := {}
    var cost_so_far := {}

    came_from[unit.coord] = null
    cost_so_far[unit.coord] = 0

    while frontier.size() > 0:
        var current: Vector2i = frontier.pop_front()

        if current == target_tile:
            break

        for next in HexUtils.get_adjacent_hex(current):
            if is_blocked(next):
                continue

            var new_cost = cost_so_far[current] + Constants.TILES[Game.stage.map.get_cell_source_id(next)]["movement_cost"]
            if not cost_so_far.has(next) or new_cost < cost_so_far[next]:
                cost_so_far[next] = new_cost
                came_from[next] = current
                frontier.push_back(next)

    # Reconstruct path
    var path: Array[Vector2i] = []
    var c := target_tile
    while c != null and c != unit.coord:
        path.push_front(c)
        c = came_from.get(c, null)

    var t := create_tween()
    t.set_trans(Tween.TRANS_LINEAR)
    t.set_ease(Tween.EASE_IN_OUT)
    for tile in path:
        t.tween_property(unit, "position", HexUtils.tile_to_px(tile), 0.1)
    await t.finished

    Game.stage.unit.at.erase(unit.coord)
    unit.coord = target_tile
    Game.stage.unit.at[target_tile] = unit
    Game.stage.unit.recompute_tiles()