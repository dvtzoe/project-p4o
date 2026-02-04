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
    var file = FileAccess.open("res://assets/story/days/%d/%s.json" % [SaveManager.current_save.day, SaveManager.current_save.route], FileAccess.READ)
    if file:
        var yaml_content: String = file.get_as_text()
        var story_data = JSON.parse_string(yaml_content)
        story_instance.load_story(story_data)
    file.close()

func _ready() -> void:
    start_story()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        var pause_menu_scene = preload("res://src/game/pause_menu/pause_menu.tscn")
        var pause_menu_instance = pause_menu_scene.instantiate()
        get_tree().current_scene.add_child(pause_menu_instance)
        get_tree().paused = true
