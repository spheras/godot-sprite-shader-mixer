@tool
class_name PluginSpriteShaderMixerEditorPlugin
extends EditorPlugin

var tool_create_plugin = preload("res://addons/sprite-shader-mixer/src/plugin/SpriteShaderMixerEditorInspectorPlugin.gd")

func _enter_tree():
	tool_create_plugin = tool_create_plugin.new()
	add_inspector_plugin(tool_create_plugin)


func _exit_tree():
	remove_inspector_plugin(tool_create_plugin)
