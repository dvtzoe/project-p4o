extends SharpMeleeAttackAction

@export var attack_power: int = 50

var action_name := "Katana Slash"

func compute_actionable_tiles() -> void:
    unit.actionable_tiles[name].clear()
    unit.action_reachable_tiles[name].clear()
    var neighbors: Array[Vector2i] = HexUtils.get_adjacent_hex(unit.coord)
    for neighbor in neighbors:
        if Game.stage.state.unit_at.has(neighbor):
            var target_unit: Unit = Game.stage.state.unit_at[neighbor]
            if target_unit.team != unit.team:
                unit.actionable_tiles[name].append(neighbor)
        else:
            unit.action_reachable_tiles[name].append(neighbor)

func perform(target: Vector2i) -> void:
    if not Game.stage.state.unit_at.has(target):
        return
    var target_unit: Unit = Game.stage.state.unit_at[target]
    if target_unit.team == unit.team:
        return
    print("%s attacks %s with Katana Slash for %d damage!" % [unit.name, target_unit.name, attack_power])
