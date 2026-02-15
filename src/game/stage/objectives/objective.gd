extends VBoxContainer

class_name StageObjective

signal all_objectives_completed
signal objective_completed(objective_index: int)

@export var objectives_container: VBoxContainer

var objective_states: Array[Dictionary] = []

func setup(objective_resources: Array[ObjectiveResource]) -> void:
    objective_states.clear()
    for res in objective_resources:
        objective_states.append({
            "resource": res,
            "completed": false,
        })
    Game.stage.unit.unit_spawned.connect(_on_unit_spawned)
    refresh()

func _on_unit_spawned(unit: Unit) -> void:
    unit.unit_died.connect(_on_unit_died)

func _on_unit_died(_unit: Unit) -> void:
    check_objectives()

func check_objectives() -> void:
    var all_done := true
    for i in range(objective_states.size()):
        var obj = objective_states[i]
        if obj["completed"]:
            continue
        var res: ObjectiveResource = obj["resource"]
        var was_completed = obj["completed"]
        
        obj["completed"] = res.is_completed()
        
        if not was_completed and obj["completed"]:
            print("Objective %d completed: %s" % [i, res.get_display_text()])
            objective_completed.emit(i)
        
        if not obj["completed"]:
            all_done = false
    
    refresh()
    if all_done and objective_states.size() > 0:
        all_objectives_completed.emit()

func toggle() -> void:
    visible = not visible

func refresh() -> void:
    for child in objectives_container.get_children():
        child.queue_free()
    for obj in objective_states:
        var res: ObjectiveResource = obj["resource"]
        if res.hidden:
            continue
        var label := Label.new()
        var status = "[x] " if obj["completed"] else "[ ] "
        label.text = status + res.get_display_text()
        objectives_container.add_child(label)

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_objectives"):
        toggle()
