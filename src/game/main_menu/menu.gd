extends Control

class_name MainMenu

@export var play_button: Button

func _ready() -> void:
	# Signals are connected in the scene file
	pass

func _on_new_button_pressed() -> void:
	SaveManager.new_save()
	fade_out(0.5)
	await get_tree().create_timer(0.5).timeout
	Game.change_state(Game.States.PLACE)


func _on_load_button_pressed() -> void:
	if SaveManager.has_save("slot0"):
		fade_out(0.5)
		await get_tree().create_timer(0.5).timeout
		SaveManager.load("slot0")
		Game.change_state(Game.States.PLACE)


func _on_setting_button_pressed() -> void:
	fade_out(0.3)
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://src/game/main_menu/option_menu.tscn")


func _on_quit_buttion_pressed() -> void:
	get_tree().quit()

func fade_out(duration: float = 0.5):
	var fade = ColorRect.new()
	fade.color = Color.BLACK
	fade.anchor_left = 0
	fade.anchor_right = 1
	fade.anchor_top = 0
	fade.anchor_bottom = 1
	fade.modulate.a = 0
	
	add_child(fade)
	
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, duration)
