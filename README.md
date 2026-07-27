# STDJson

A lightweight **Godot 4 JSON utility addon** that simplifies reading, writing, and handling JSON data.

STDJson provides a global autoload that allows you to:

- Parse JSON from strings.
- Parse JSON from files.
- Save JSON data into files.
- Automatically fix Godot's JSON number conversion behavior.

---

## Features

- 📖 Parse JSON from a file.
- 📝 Parse JSON from a string.
- 💾 Save JSON data to a file.
- ✨ Optional pretty formatting.
- 🔢 Automatically converts whole-number floats into integers.
- 📦 Supports both JSON objects (`Dictionary`) and JSON arrays (`Array`).
- 🚀 Available globally through the `STDJson` autoload.

---

# Why STDJson?

Godot's built-in JSON parser converts all JSON numbers into floating-point values.

For example, this JSON:

```json
{
	"id": 1,
	"health": 100,
	"speed": 2.5
}
```

will become:

```gdscript
{
	"id": 1.0,
	"health": 100.0,
	"speed": 2.5
}
```

STDJson automatically converts numbers without a fractional part back into integers:

```gdscript
{
	"id": 1,
	"health": 100,
	"speed": 2.5
}
```

Examples:

```
2.0  -> 2
15.0 -> 15
2.5  -> 2.5
```

This makes JSON data easier to work with when handling IDs, counters, levels, ports, and other integer-based values.

---

# Installation

1. Copy the addon folder into your project's `addons` directory.

Example:

```
res://addons/STDJson/
```

2. Open:

```
Project → Project Settings → Plugins
```

3. Enable the **STDJson** plugin.

4. The plugin automatically creates the:

```
STDJson
```

autoload.

You can now use it anywhere in your project.

---

# Usage

## Parse JSON from a file

```gdscript
var data: Variant = STDJson.parse_file("user://settings.json")

if data == null:
    return
```

---

## Parse JSON from a string

```gdscript
var data: Variant = STDJson.parse_string("""
{
    "player": {
        "name": "Alice",
        "level": 10
    }
}
""")
```

---

## Modify JSON data

```gdscript
data["player"]["level"] += 1
```

---

## Save JSON data to a file

```gdscript
var result := STDJson.save_json_to_file(
    data,
    "user://settings.json"
)

if result == OK:
    print("Saved successfully!")
```

---

## Save without formatting

By default, JSON files are saved in a readable formatted style.

To save a compact JSON file:

```gdscript
STDJson.save_json_to_file(
    data,
    "user://settings.json",
    false
)
```

---

## Save an existing JSON string

```gdscript
var json_string := """
{
    "name": "Alice",
    "coins": 500
}
"""

STDJson.save_json_to_file(
    json_string,
    "user://save.json"
)
```

---

# API Reference

## `parse_file(path: String) -> Variant`

Reads a JSON file and converts it into a Godot value.

Returns:

- `Dictionary`
- `Array`
- `null` if reading or parsing fails

Example:

```gdscript
var save_data = STDJson.parse_file("user://save.json")
```

---

## `parse_string(json_string: String) -> Variant`

Parses a JSON string and converts it into a Godot value.

Returns:

- `Dictionary`
- `Array`
- `null` if parsing fails

Example:

```gdscript
var data = STDJson.parse_string(json_text)
```

---

## `save_json_to_file(json: Variant, path: String, formatted: bool = true) -> int`

Saves JSON data into a file.

Accepted input types:

- `Dictionary`
- `Array`
- JSON `String`

Returns:

- `OK` on success
- `FAILED` on error

Example:

```gdscript
var error := STDJson.save_json_to_file(
    data,
    "user://save.json"
)
```

---

# Complete Example

```gdscript
func _ready() -> void:
    var player_data: Variant = STDJson.parse_file(
        "user://player.json"
    )

    if player_data == null:
        return

    player_data["coins"] += 100
    player_data["level"] += 1

    var result := STDJson.save_json_to_file(
        player_data,
        "user://player.json"
    )

    if result == OK:
        print("Game saved!")
```

---

# Notes

- STDJson works with both JSON objects and JSON arrays.
- JSON files are stored as UTF-8 text.
- Saved JSON can be formatted or compact.
- Whole-number floating values are automatically converted into integers.
- Floating-point values containing fractions are preserved.
- Invalid JSON returns `null`.

---

# License

This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)**.

You are free to use, modify, and redistribute this software under the terms of the GPL-3.0 license.

See the [LICENSE](LICENSE) file for the complete license text.
