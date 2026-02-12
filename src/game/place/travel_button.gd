extends Button

class_name TravelButton

func _pressed() -> void:
    Game.change_state(Game.States.TRAVEL)