extends TextureButton

class_name StageButton

@export var stage_resource: StageResource

func _pressed() -> void:
    Game.change_state(Game.States.STAGE)
    Game.stage.start(stage_resource)