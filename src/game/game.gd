extends Node

func start_stage() -> void:
    var stage_scene = preload("res://src/game/stage/stage.tscn")
    var stage_instance = stage_scene.instantiate()
    get_tree().current_scene.add_child(stage_instance)

func start_story() -> void:
    var story_scene = preload("res://src/game/story/story.tscn")
    var story_instance = story_scene.instantiate()
    story_instance.connect("start_stage", Callable(self , "start_stage"))
    get_tree().current_scene.add_child(story_instance)

func _ready() -> void:
    start_story()
