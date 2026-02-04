extends Camera2D

@export var move_speed: float = 512.0

func _process(delta: float) -> void:
    var input_vector = Vector2.ZERO
    if Input.is_action_pressed("move_up"):
        input_vector.y -= 1
    if Input.is_action_pressed("move_down"):
        input_vector.y += 1
    if Input.is_action_pressed("move_left"):
        input_vector.x -= 1
    if Input.is_action_pressed("move_right"):
        input_vector.x += 1

    if input_vector != Vector2.ZERO:
        input_vector = input_vector.normalized()
        if Input.is_action_pressed("speed_up"):
            input_vector *= 2.0
        if Input.is_action_pressed("speed_down"):
            input_vector *= 0.5
        position += input_vector * move_speed * delta
