extends Node

class_name MainScene

const PAUSE_MENU_SCENE := preload("res://src/game/pause_menu/pause_menu.tscn")

@export var notifications_container: VBoxContainer
@export var canvas: CanvasLayer
@export var game: Node

var pause_menu: PauseMenu

func toggle_pause_menu() -> void:
	if pause_menu != null:
		pause_menu.queue_free()
		pause_menu = null
	else:
		pause_menu = PAUSE_MENU_SCENE.instantiate() as PauseMenu
		canvas.add_child(pause_menu)

func _ready() -> void:
	Notification.notification_container = notifications_container
	#SigBus.toggle_pause_menu.connect(toggle_pause_menu)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SigBus.toggle_pause_menu.emit()
