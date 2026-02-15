extends ObjectiveResource

class_name ObjectiveKillAllEnemies

func is_completed() -> bool:
    for unit: Unit in Game.stage.unit.at.values():
        if unit.team == Unit.Team.ENEMY and not unit.is_dying:
            return false
    return true

func get_display_text() -> String:
    return "Defeat all enemies"
