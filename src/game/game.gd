extends Node


func _ready() -> void:
    var story_scene = preload("res://src/game/story/story.tscn")
    var story_instance = story_scene.instantiate()
    story_instance.start("res://assets/story/days/%d/%s.json" % [SaveManager.current_save.day, SaveManager.current_save.route])
    get_tree().current_scene.add_child(story_instance)
