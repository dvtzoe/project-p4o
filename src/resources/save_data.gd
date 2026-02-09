extends Resource

class_name SaveData

## Days passed
var day: int = 0

## Current time (0-23)
var time: int = 8

## Current route
var route: String = "default"

## Datables owned by the player
var datables: Dictionary[String, Datable] = {}