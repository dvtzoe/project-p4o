extends Control

class_name MainMenu

@export var play_button: Button


func _on_new_button_pressed() -> void:
    SaveManager.new_save()
    Game.change_state(Enums.GameState.STORY)
    var story_file = FileAccess.open("res://assets/story/days/0/default.json", FileAccess.READ)
    var story_data = JSON.parse_string(story_file.get_as_text())
    Game.story.load_story(story_data)
    story_file.close()


func _on_load_button_pressed() -> void:
    pass
