extends Node

var state: Enums.GameState = Enums.GameState.MAIN_MENU

var lobby_scene := preload("res://src/game/lobby/lobby.tscn")
var main_menu_scene := preload("res://src/game/main_menu/menu.tscn")
var stage_scene := preload("res://src/game/stage/stage.tscn")
var story_scene := preload("res://src/game/story/story.tscn")

var lobby: Lobby
var main_menu: MainMenu
var stage: Stage
var story: Story

func change_state(new_state: Enums.GameState) -> void:
    state = new_state
    for child in get_children():
        child.queue_free()
    match state:
        Enums.GameState.LOBBY:
            lobby = lobby_scene.instantiate()
            add_child(lobby)
        Enums.GameState.MAIN_MENU:
            main_menu = main_menu_scene.instantiate()
            add_child(main_menu)
        Enums.GameState.STORY:
            story = story_scene.instantiate()
            add_child(story)
        Enums.GameState.STAGE:
            stage = stage_scene.instantiate()
            add_child(stage)

func _ready() -> void:
    change_state(Enums.GameState.MAIN_MENU)
