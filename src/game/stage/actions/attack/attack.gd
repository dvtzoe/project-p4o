extends Action

class_name AttackAction

@export var attack_type: Enums.AttackType
@export var element: Enums.Element

func _ready() -> void:
    action_type = Enums.ActionType.ATTACK