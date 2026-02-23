extends Control

class_name Story

const STORY_SPRITE_SCENE = preload("res://src/game/story/story_sprite.tscn")

@export var name_label: Label
@export var content_label: RichTextLabel
@export var background_texture_rect: TextureRect
@export var choices_container: VBoxContainer
@export var sprites_node: Node

signal ui_accept_pressed
signal choice_made(index)
signal scene_ready

var is_ready: bool = false
var is_streaming: bool = false
var char_index: int = 0
var full_text: String = ""
var buffered_text: String = ""
var time_since_last_char: float = 0.0
var char_interval: float = 0.05
var is_skipping: bool = false

func _on_choice_made(index: int) -> void:
    emit_signal("choice_made", index)

func load_story(story_data: Array[StoryEntry]) -> void:
    if not is_ready:
        await scene_ready
    for entry in story_data:
        if entry is BackgroundStoryEntry:
            if Config.config.debug_skip_story:
                continue
            background_texture_rect.texture = entry.background
        elif entry is DialogueStoryEntry:
            if Config.config.debug_skip_story:
                continue
            if is_skipping:
                name_label.text = entry.character
                content_label.text = entry.text
                continue
            content_label.clear()
            name_label.text = entry.character
            full_text = entry.text
            buffered_text = ""
            char_index = 0
            time_since_last_char = 0.0
            is_streaming = true
            await ui_accept_pressed
            is_streaming = false
        elif entry is ChoiceStoryEntry:
            if Config.config.debug_skip_story:
                continue
            is_skipping = false
            var choice_scene = preload("res://src/game/story/choice_container.tscn")
            for i in range(entry.choices.size()):
                var choice_instance = choice_scene.instantiate()
                choice_instance.set("index", i)
                choice_instance.connect("choice_made", Callable(self , "_on_choice_made"))
                var button = choice_instance.get_node("Button")
                button.text = entry.choices[i].text
                choices_container.add_child(choice_instance)
            var choice_index = await choice_made
            print("Player chose option %d" % choice_index)
            for child in choices_container.get_children():
                child.queue_free()
            
        elif entry is StageStoryEntry:
            Game.change_state(Game.States.STAGE)
            Game.stage.start(entry.map)

        elif entry is NewSpriteStoryEntry:
            var sprite_instance := STORY_SPRITE_SCENE.instantiate() as TextureRect
            sprite_instance.texture = entry.sprite_texture
            sprite_instance.name = entry.sprite_id
            sprites_node.add_child(sprite_instance)

        else:
            print("Unknown story entry type: %s" % entry.type)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed or event.is_action_pressed("ui_accept"):
        if is_streaming:
            content_label.text = full_text
            is_streaming = false
        else:
            emit_signal("ui_accept_pressed")
    if event.is_action_pressed("skip"):
        is_skipping = true
        emit_signal("ui_accept_pressed")


func _process(delta: float) -> void:
    if is_streaming and not is_skipping:
        time_since_last_char += delta
        if time_since_last_char > char_interval:
            time_since_last_char = 0.0
            if char_index < full_text.length():
                buffered_text += full_text[char_index]
                content_label.text = buffered_text
                char_index += 1
            else:
                is_streaming = false

func _ready() -> void:
    is_ready = true
    scene_ready.emit()
