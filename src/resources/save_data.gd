extends Resource

class_name SaveData

const VERSION := 1

## Days passed
var day: int = 0

## Current time (0-23)
var time: int = 8

## Current route
var route: String = "default"

## Datables owned by the player
var datables: Dictionary[String, Datable] = {}

## Current story resource path (e.g. "res://data/stories/intro.tres")
var story_id: String = ""

## Index into the story's entry array (position within the story)
var story_index: int = 0

func to_dict() -> Dictionary:
    var datables_dict := {}
    for key in datables:
        datables_dict[key] = datables[key].to_dict()
    return {
        "version": VERSION,
        "saved_at": Time.get_datetime_string_from_system(),
        "day": day,
        "time": time,
        "route": route,
        "datables": datables_dict,
        "story_id": story_id,
        "story_index": story_index,
    }

static func from_dict(d: Dictionary) -> SaveData:
    var version: int = d.get("version", 0)

    # --- migrations ---
    if version < 1:
        d["story_id"] = d.get("story_id", "")
        d["story_index"] = d.get("story_index", 0)

    var save := SaveData.new()
    save.day = d.get("day", 0)
    save.time = d.get("time", 8)
    save.route = d.get("route", "default")
    save.story_id = d.get("story_id", "")
    save.story_index = d.get("story_index", 0)

    var datables_raw: Dictionary = d.get("datables", {})
    for key in datables_raw:
        save.datables[key] = Datable.from_dict(datables_raw[key])

    return save
