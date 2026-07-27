@tool
extends EditorPlugin

const AUTOLOAD_NAME := "STDJson"
const AUTOLOAD_PATH := "res://addons/stdjson/stdjson.gd"


func _enable_plugin():
	if not ProjectSettings.has_setting("autoload/" + AUTOLOAD_NAME):
		add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)


func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_NAME)
