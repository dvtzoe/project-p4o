# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Project P4O** is a Godot 4.6 game combining hex-grid tactical battles with visual novel/dating sim elements, written in GDScript. The renderer is GL Compatibility.

There is no build system or test framework — the project is run and tested through the Godot editor. Open the project in Godot 4.6+ and press F5 (or the play button).

## Architecture

### Game State Machine (Autoload: `Game`)

The `Game` autoload (`src/autoloads/game.gd`) is the central scene manager. It owns the lifecycle of 6 major states, switching between them by clearing children and instantiating the corresponding scene:

- **main_menu** — Title screen
- **place** — Hub area for character (datable) interactions
- **story** — Visual novel engine with streaming text, choices, backgrounds, and embedded stage battles
- **stage** — Hex-grid tactical battle (the core gameplay)
- **travel** — Destination selection menu
- **explore** — Mission/stage selection (placeholder)

Call `Game.change_state("state_name")` to transition. The Game singleton holds references like `Game.stage`, `Game.story`, etc. for cross-system access.

### Other Autoloads

- **SaveManager** — Save/load via `.tres` Resource files in `user://saves/`. Holds `current_save: SaveData`.
- **Config** — Development flags (e.g. `debug_skip_story`).
- **Notification** — Toast notification system. Call `Notification.notify(NotificationData.new())`.

### Stage (Battle) System

The most complex subsystem. Key nodes are exported on the Stage scene and coordinated by `StageState`:

- **StageState** (`src/game/stage/state.gd`) — Battle coordinator. Manages phases (`preparation` → `playing` → `completed`), tile selection, overlay computation, and turn flow.
- **StageUnit** (`src/game/stage/unit.gd`) — Unit registry. Maintains `at: Dictionary[Vector2i, Unit]` spatial hash. Handles spawn/despawn and recomputes movement/action ranges.
- **Map** (`src/game/stage/map.gd`) — TileMapLayer that handles all stage mouse input (click to select/move/attack, hover for spawn preview).
- **Spawner** (`src/game/stage/spawner/spawner.gd`) — UI for placing player units during preparation phase.
- **Overlay** (`src/game/stage/overlay.gd`) — Static singleton for tile highlighting with a stack-based state system (MOVE_REACHABLE, ATTACKABLE, etc.).
- **Camera** (`src/game/stage/camera.gd`) — WASD/HJKL movement with zoom.

### Unit Component System

Units (`src/game/stage/units/unit.gd`) use component composition:

- **Movement** — Flood-fill reachable tile computation, A* pathfinding with tween animation.
- **Health** — HP tracking, damage, death.
- **Actions** — Child nodes under an "Actions" container. Base class `Action` has abstract `perform(target)` and `compute_actionable_tiles()`. `AttackAction` extends with attack_type/element.

Components reference their parent unit via `@onready var unit = get_parent()`.

### Story System

The story engine (`src/game/story/story.gd`) processes `Array[StoryEntry]` sequentially using async/await. Entry types:

- **DialogueStoryEntry** — Character name + streaming text
- **BackgroundStoryEntry** — Scene background change
- **ChoiceStoryEntry** — Branching choices
- **StageStoryEntry** — Embeds a full tactical battle mid-story

Story can also appear mid-battle via the wave hook system (`StoryHook`).

### Resource / Data Layer

Content is data-driven using Godot Resources (`.tres` files in `data/`):

- **StageResource** → waves (`StageWave`) → spawn entries + hook entries
- **StoryResource** → array of `StoryEntry` subtypes
- **SaveData** — day, time (0-23), route, owned datables
- **Datable** — Character with level/points progression (100 + level*100 per level-up)

### Hex Grid

Uses offset coordinates with row-parity handling. Key utility: `src/utils/hex_utils.gd` — `tile_to_px()`, `get_adjacent_hex()`. Tile size is `Vector2i(110, 128)`. Tile properties (movement cost) defined in `src/utils/constants.gd`.

## Editing Rules

- **Only write `.gd` files.** Never directly edit `.tscn` (scene) or `.tres` (resource) files. These are managed by the Godot editor. If a change requires modifying a `.tscn` or `.tres` file, describe the desired change to the user so they can make it in the editor.

## Key Conventions

- Enums are centralized in `src/utils/enums.gd` (AttackType, Element, OverlayState).
- Constants/lookup tables live in `src/utils/constants.gd` (UNITS_TABLE, TILES).
- Input actions are defined in `project.godot` — movement uses both WASD and HJKL (vim-style).
- The stage dynamically loads map scenes from `data/maps/` at runtime via `StageResource.map`.
- Unit scenes live under `src/game/stage/units/` organized by type (pieces, structures).
- Action scenes are nested under `src/game/stage/actions/` by category (attack/melee/sharp/...).
