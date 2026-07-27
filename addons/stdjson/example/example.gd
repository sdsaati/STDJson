extends Control


func _ready() -> void:
	var json: Dictionary = STDJson.parse_file("res://addons/stdjson/example/example.json")
	my_custom_print(json,["address",0,"port"])
	my_custom_print(json,["address",0,"listen"])
	my_custom_print(json,["locations"])
	print()
	
	json["address"][0]["port"] = "2090"
	STDJson.save_json_to_file(json, "res://addons/stdjson/example/example.json")
	print("We saved string '2090' into example.json file")
	my_custom_print(json,["address",0,"port"])
	print()
	
	json["address"][0]["port"] = 2090.5
	STDJson.save_json_to_file(json, "res://addons/stdjson/example/example.json")
	print("We saved float 2090.5 into example.json file")
	my_custom_print(json,["address",0,"port"])
	print()
	
	json["address"][0]["port"] = 2090
	STDJson.save_json_to_file(json, "res://addons/stdjson/example/example.json")
	print("We saved int 2090 into example.json file")
	my_custom_print(json,["address",0,"port"])
	print()


func my_custom_print(data: Variant, path: Array):
	var value = data
	var path_string := ""

	for key in path:
		value = value[key]

		if key is String:
			path_string += "[\"" + key + "\"]"
		else:
			path_string += "[" + str(key) + "]"

	print(
		path_string,
		" = ",
		value,
		" (", type_string(typeof(value)), ")"
	)
