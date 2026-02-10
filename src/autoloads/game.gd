extends Node

var state: String

const PLACE_SCENE := preload("res://src/game/place/place.tscn")
const MAIN_MENU_SCENE := preload("res://src/game/main_menu/menu.tscn")
const STAGE_SCENE := preload("res://src/game/stage/stage.tscn")
const STORY_SCENE := preload("res://src/game/story/story.tscn")
const TRAVEL_SCENE := preload("res://src/game/travel/travel.tscn")
const EXPLORE_SCENE := preload("res://src/game/explore/explore.tscn")

var place: Place
var main_menu: MainMenu
var stage: Stage
var story: Story
var travel: Travel
var explore: Explore

func change_state(new_state: String) -> void:
    state = new_state
    for child in get_children():
        child.queue_free()
    match state:
        "place":
            place = PLACE_SCENE.instantiate()
            add_child(place)
        "main_menu":
            main_menu = MAIN_MENU_SCENE.instantiate()
            add_child(main_menu)
        "story":
            story = STORY_SCENE.instantiate()
            add_child(story)
        "stage":
            stage = STAGE_SCENE.instantiate()
            add_child(stage)
        "travel":
            travel = TRAVEL_SCENE.instantiate()
            add_child(travel)
        "explore":
            explore = EXPLORE_SCENE.instantiate()
            add_child(explore)

func _ready() -> void:
    change_state("main_menu")
