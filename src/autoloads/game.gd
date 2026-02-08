extends Node

enum State {
    PLACE,
    MAIN_MENU,
    STORY,
    STAGE,
}


var state: State = State.MAIN_MENU

var place_scene := preload("res://src/game/place/place.tscn")
var main_menu_scene := preload("res://src/game/main_menu/menu.tscn")
var stage_scene := preload("res://src/game/stage/stage.tscn")
var story_scene := preload("res://src/game/story/story.tscn")

var place: Place
var main_menu: MainMenu
var stage: Stage
var story: Story

func change_state(new_state: State) -> void:
    state = new_state
    for child in get_children():
        child.queue_free()
    match state:
        State.PLACE:
            place = place_scene.instantiate()
            add_child(place)
        State.MAIN_MENU:
            main_menu = main_menu_scene.instantiate()
            add_child(main_menu)
        State.STORY:
            story = story_scene.instantiate()
            add_child(story)
        State.STAGE:
            stage = stage_scene.instantiate()
            add_child(stage)

func _ready() -> void:
    change_state(State.MAIN_MENU)
