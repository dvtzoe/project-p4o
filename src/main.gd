extends Node

class_name MainScene

const PAUSE_MENU_SCENE := preload("res://src/game/pause_menu/pause_menu.tscn")

@export var notifications_container: VBoxContainer

var pause_menu: PauseMenu

func _ready() -> void:
    Notification.notification_container = notifications_container

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_cancel"):
        if pause_menu != null:
            pause_menu.queue_free()
            pause_menu = null
        else:
            pause_menu = PAUSE_MENU_SCENE.instantiate() as PauseMenu
            add_child(pause_menu)
