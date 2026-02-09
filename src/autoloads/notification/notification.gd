extends Node

var notification_container: VBoxContainer

const NOTIFICATION_SCENE = preload("res://src/autoloads/notification/notification_entry.tscn")
const TIME_TO_LIVE := 4.0

func notify(data: NotificationData) -> void:
    if notification_container == null:
        push_error("Notification container is not set.")
        return
    var notification_entry = NOTIFICATION_SCENE.instantiate() as NotificationEntry
    notification_entry.setup(data)
    notification_container.add_child(notification_entry)
    var timer = Timer.new()
    timer.wait_time = TIME_TO_LIVE
    timer.one_shot = true
    timer.timeout.connect(func() -> void:
        notification_entry.queue_free()
        timer.queue_free()
    )
    add_child(timer)
    timer.start()
