@tool
extends VBoxContainer
class_name ShaderInfoContainer

signal onDeleteShader(shaderInfo:ShaderInfo)
signal onReorder(shaderInfo:ShaderInfo,after:bool)

@onready var comp_name:Label=$container_name/container_title/container_name_separator/label_name
@onready var comp_delete:Button=$container_name/button_delete
@onready var comp_author:Label=$container_author/text_author
@onready var comp_version:Label=$container_version/text_version
@onready var comp_description:Label=$container_description/text_description
@onready var comp_buttonUp:Button=$container_name/container_title/container_updown/button_up
@onready var comp_buttonDown:Button=$container_name/container_title/container_updown/button_down

var shaderInfo:ShaderInfo

func loadShaderInfo(shaderInfo:ShaderInfo)->void:
	comp_name.text=shaderInfo.name
	comp_author.text=shaderInfo.author
	comp_version.text=shaderInfo.version
	comp_description.text=shaderInfo.description
	self.comp_delete.pressed.connect(self._onDeleteButtonPressed)
	self.comp_buttonUp.pressed.connect(self._onButtonUp)
	self.comp_buttonDown.pressed.connect(self._onButtonDown)
	self.shaderInfo=shaderInfo

func _onButtonUp():
	self.onReorder.emit(self.shaderInfo, false)

func _onButtonDown():
	self.onReorder.emit(self.shaderInfo, true)
		
func _onDeleteButtonPressed():
	self.onDeleteShader.emit(self.shaderInfo)
