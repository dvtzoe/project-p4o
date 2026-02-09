extends Node

class_name MainScene

@export var notifications_container: VBoxContainer

func _ready() -> void:
    Notification.notification_container = notifications_container