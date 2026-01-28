extends Control

@export var name_label: Label
@export var content_label: RichTextLabel
@export var background_texture_rect: TextureRect

signal ui_accept_pressed

func load_story(file_path: String) -> void:
    var file = FileAccess.open(file_path, FileAccess.READ)
    if file:
        var yaml_content = file.get_as_text()
        var story_data = JSON.parse_string(yaml_content)
        if story_data.has("story"):
            for entry in story_data["story"]:
                match entry["type"]:
                    "background":
                        var bg_texture = load(entry["file"])
                        if not bg_texture:
                            print("Failed to load background texture: %s" % entry["file"])
                        else:
                            background_texture_rect.texture = bg_texture
                    "dialogue":
                        name_label.text = entry["text"]
                        content_label.text = entry["text"]
                        await ui_accept_pressed
                    _:
                        print("Unknown story entry type: %s" % entry["type"])
                    
    file.close()


func start(file_path: String) -> void:
    load_story(file_path)


func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed or event.is_action_pressed("ui_accept"):
        emit_signal("ui_accept_pressed")
