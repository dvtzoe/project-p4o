extends Resource

class_name ObjectiveResource

@export var hidden: bool = false
@export var hooks: Array[HookEntry] = []

func is_completed() -> bool:
	push_error("is_completed() must be implemented by subclass")
	return false

func get_display_text() -> String:
	push_error("get_display_text() must be implemented by subclass")
	return ""
