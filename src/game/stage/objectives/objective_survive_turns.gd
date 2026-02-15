extends ObjectiveResource

class_name ObjectiveSurviveTurns

@export var target_turn: int = 1

func is_completed() -> bool:
    return Game.stage.state.current_turn >= target_turn

func get_display_text() -> String:
    return "Survive turn %d" % target_turn
