extends Control

@export var name_label: Label
@export var content_label: RichTextLabel
@export var background_texture_rect: TextureRect

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
						background_texture_rect.texture = bg_texture
					"name":
						name_label.text = entry["text"]
					"content":
						content_label.text = entry["text"]
					_:
						print("Unknown story entry type: %s" % entry["type"])
					
	file.close()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
