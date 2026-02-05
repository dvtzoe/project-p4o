class_name Movements

static func dijkstra_reachable_tiles(
    start: Vector2i,
    movement_points: int,
) -> Dictionary[Vector2i, int]:
    var reachable_tiles: Dictionary[Vector2i, int] = {}
    var frontier: Array[Dictionary] = []
    frontier.append({"position": start, "cost": 0})
    
    while frontier.size() > 0:
        var current = frontier.pop_front()
        var current_pos: Vector2i = current["position"]
        var current_cost: int = current["cost"]
        
        if current_pos in reachable_tiles:
            continue
        
        if current_pos != start:
            reachable_tiles[current_pos] = current_cost
        
        if current_cost >= movement_points:
            continue
        
        var neighbors: Array[Vector2i] = HexUtils.get_adjacent_hex(current_pos)
        for neighbor in neighbors:
            if StageState.instance.unit_at.has(neighbor):
                continue
            if StageState.instance.tile_map_layer.get_cell_source_id(neighbor) == -1:
                continue
            frontier.append({"position": neighbor, "cost": current_cost + Constants.TILES[StageState.instance.tile_map_layer.get_cell_source_id(neighbor)]["movement_cost"]})
    
    return reachable_tiles