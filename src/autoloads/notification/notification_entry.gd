extends PanelContainer

class_name NotificationEntry

@export var title_label: Label
@export var message_label: Label

func setup(data: NotificationData) -> void:
    title_label.text = data.title
    message_label.text = data.message
