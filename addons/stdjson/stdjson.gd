@icon("./icon.svg")
extends Node

# -- General Documentation About This Script --
## Enable this plugin in your project settings, then you will have STDJson autoload. [br]
## Now You can read from string or file, and also write into json file using this script
## [codeblock]
## # Suppose we are in main.gd (of main.tscn):
## func _ready() -> void:
##    # load a json file as a Godot Variant (Dictionary or Array)
##    var my_json: Variant = STDJson.parse_file("user://my_json.json")
##    # or load from a json string
##    var my_json = STDJson.parse_string("""
##        {
##        	"bla": {
##        		"blabla": "Hi"
##        	}
##        }
##        """)
##    # use it and modify it ...
##    my_json["bla"]["blabla"] = "blablabla"
##    # save it into file
##    if STDJson.save_json_to_file("user://new.json") == OK:
##        print("Saved")
##
## [/codeblock]
##

# -- Signals --
@warning_ignore("unused_signal") # because it's used with call_deferred


# -- Exported Vars --


# -- Vars --


# -- Methods (public) --
## You will use this for parsing a json string. It actually [br]
## Coverts a json string to a Godot Variant (Dictionary or Array) that can be used in your codes.
func parse_string(json_string: String) -> Variant:
	return self._parse(json_string)


## Coverts a json file to a Godot Variant (Dictionary or Array) that can be used in your codes.
func parse_file(json_file_path: String) -> Variant:
	var path = ProjectSettings.globalize_path(json_file_path)
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open " + path + " for reading")
		return
	var json_string = file.get_as_text()
	file.close()
	return self._parse(json_string)


## This method accepted one of: [br]
## json string / json Godot Variant (Dictionary or Array) [br]
## and will save it into the given path as a json file
func save_json_to_file(json: Variant, path: String, formatted: bool = true) -> int:
	path = ProjectSettings.globalize_path(path)
	var jsonStr: String
	var format_character: String
	if formatted:
		format_character = "\t"
	else:
		format_character = ""
	
	if json is Dictionary or json is Array:
		jsonStr = JSON.stringify(json, format_character, false, true)
	elif json is String:
		jsonStr = json
	else:
		push_error("json must be a Dictionary, Array, or String.")
		return FAILED

	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open " + path + " for writing")
		return FAILED
	file.store_string(jsonStr)
	file.close()
	return OK


# -- Methods (private) --
## This method, gets a json Godot Variant (Dictionary or Array) that is parsed by Godot json library [br]
## and then fix floatings numbers by converting them to integer [br]
## ex: 2.0 will be converted to 2 but 2.5 will be 2.5
func _fix_numbers(json_data: Variant) -> Variant:
	var stack = [json_data]
	while not stack.is_empty():
		var current = stack.pop_back()

		if current is Dictionary:
			for key in current:
				var value = current[key]

				if value is Dictionary or value is Array:
					stack.push_back(value)
				elif value is float and value == floor(value):
					current[key] = int(value)

		elif current is Array:
			for i in range(current.size()):
				var value = current[i]

				if value is Dictionary or value is Array:
					stack.push_back(value)
				elif value is float and value == floor(value):
					current[i] = int(value)
	return json_data


## Converts a json string to a json Godot Variant (Dictionary or Array) that can be used in Godot [br]
## but also fixes its numbering issues (ex: 2.0 will be 2)
func _parse(jsonString: Variant) -> Variant:
	var parsed_json: Variant
	var js: String
	if typeof(jsonString) == TYPE_PACKED_BYTE_ARRAY:
		js = jsonString.get_string_from_utf8()
	else:
		js = jsonString

	var json = JSON.new()
	var error = json.parse(js)
	if error == OK:
		parsed_json = _fix_numbers(json.data)
		return parsed_json
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", js, " at line ", json.get_error_line())
		return
