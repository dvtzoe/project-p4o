extends VBoxContainer

class_name StageObjective

signal all_objectives_completed

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
    print("Unit died, checking objectives...")
    check_objectives()

func check_objectives() -> void:
    var all_done := true
    for obj in objective_states:
        var res: ObjectiveResource = obj["resource"]
        match res.type:
            Enums.ObjectiveType.KILL_ALL_ENEMIES:
                obj["completed"] = _check_kill_all_enemies()
            Enums.ObjectiveType.SURVIVE_ALL_WAVES:
                obj["completed"] = _check_survive_all_waves()
        print("Objective %s completed: %s" % [res.type, obj["completed"]])
        if not obj["completed"]:
            all_done = false
    refresh()
    if all_done and objective_states.size() > 0:
        all_objectives_completed.emit()

func _check_kill_all_enemies() -> bool:
    for unit: Unit in Game.stage.unit.at.values():
        if unit.team == Unit.Team.ENEMY and not unit.is_dying:
            print("Enemy unit still alive: %s" % unit.unit_name)
            return false
    return true

func _check_survive_all_waves() -> bool:
    return Game.stage.state.waves_finished

func toggle() -> void:
    visible = not visible

func refresh() -> void:
    for child in objectives_container.get_children():
        child.queue_free()
    for obj in objective_states:
        var label := Label.new()
        var res: ObjectiveResource = obj["resource"]
        var status = "[x] " if obj["completed"] else "[ ] "
        match res.type:
            Enums.ObjectiveType.KILL_ALL_ENEMIES:
                label.text = status + "Defeat all enemies"
            Enums.ObjectiveType.SURVIVE_ALL_WAVES:
                label.text = status + "Survive all waves"
        objectives_container.add_child(label)

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_objectives"):
        toggle()
