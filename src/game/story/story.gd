extends Control

@export var name_label: Label
@export var content_label: RichTextLabel
@export var background_texture_rect: TextureRect

signal ui_accept_pressed

var is_streaming: bool = false
var char_index: int = 0
var full_text: String = ""
var buffered_text: String = ""
var time_since_last_char: float = 0.0
var char_interval: float = 0.05

func load_story(file_path: String) -> void:
    var file = FileAccess.open(file_path, FileAccess.READ)
    if file:
        var yaml_content: String = file.get_as_text()
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
                        content_label.clear()
                        name_label.text = entry["character"]
                        full_text = entry["text"]
                        buffered_text = ""
                        char_index = 0
                        time_since_last_char = 0.0
                        is_streaming = true
                        await ui_accept_pressed
                        is_streaming = false

                    _:
                        print("Unknown story entry type: %s" % entry["type"])
                    
    file.close()


func start(file_path: String) -> void:
    load_story(file_path)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed or event.is_action_pressed("ui_accept"):
        if is_streaming:
            content_label.text = full_text
            is_streaming = false
        else:
            emit_signal("ui_accept_pressed")

func _process(delta: float) -> void:
    if is_streaming:
        time_since_last_char += delta
        if time_since_last_char > char_interval:
            time_since_last_char = 0.0
            if char_index < full_text.length():
                buffered_text += full_text[char_index]
                content_label.text = buffered_text
                char_index += 1
            else:
                is_streaming = false