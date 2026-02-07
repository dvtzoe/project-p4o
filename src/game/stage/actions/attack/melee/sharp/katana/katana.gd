extends AttackAction

class_name Katana

@export var attack_power: int = 50

var action_name := "Katana Slash"

func compute_actionable_tiles() -> void:
    actionable_tiles.clear()
    action_reachable_tiles.clear()
    var neighbors: Array[Vector2i] = HexUtils.get_adjacent_hex(unit.coord)
    for neighbor in neighbors:
        if Game.stage.unit.at.has(neighbor):
            var target_unit: Unit = Game.stage.unit.at[neighbor]
            if target_unit.team != unit.team and target_unit.health:
                actionable_tiles.append(neighbor)
        else:
            action_reachable_tiles.append(neighbor)

func perform(target: Vector2i) -> void:
    if not Game.stage.unit.at.has(target):
        return
    var target_unit: Unit = Game.stage.unit.at[target]
    if target_unit.team == unit.team:
        return
    
    target_unit.health.hurt(attack_power)
