extends Node

enum States {
    MAIN_MENU = 0,
    STORY = 1,
    STAGE = 2,
    PLACE = 3,
    TRAVEL = 4,
    EXPLORE = 5,
}

const SCENES_PRELOADS := {
    States.MAIN_MENU: preload("res://src/game/main_menu/menu.tscn"),
    States.STORY: preload("res://src/game/story/story.tscn"),
    States.STAGE: preload("res://src/game/stage/stage.tscn"),
    States.PLACE: preload("res://src/game/place/place.tscn"),
    States.TRAVEL: preload("res://src/game/travel/travel.tscn"),
    States.EXPLORE: preload("res://src/game/explore/explore.tscn"),
}

@onready var game: Node = get_tree().current_scene.game

var state: States

var place: Place
var main_menu: MainMenu
var stage: Stage
var story: Story
var travel: Travel
var explore: Explore

func change_state(new_state: States) -> void:
    state = new_state
    for child in game.get_children():
        child.queue_free()
    match state:
        States.PLACE:
            place = SCENES_PRELOADS[States.PLACE].instantiate()
            game.add_child(place)
        States.MAIN_MENU:
            main_menu = SCENES_PRELOADS[States.MAIN_MENU].instantiate()
            game.add_child(main_menu)
        States.STORY:
            story = SCENES_PRELOADS[States.STORY].instantiate()
            game.add_child(story)
        States.STAGE:
            stage = SCENES_PRELOADS[States.STAGE].instantiate()
            game.add_child(stage)
        States.TRAVEL:
            travel = SCENES_PRELOADS[States.TRAVEL].instantiate()
            game.add_child(travel)
        States.EXPLORE:
            explore = SCENES_PRELOADS[States.EXPLORE].instantiate()
            game.add_child(explore)

func _ready() -> void:
    change_state(States.MAIN_MENU)
