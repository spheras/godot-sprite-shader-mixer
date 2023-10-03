@tool
class_name ShaderInfoParameterContainer
extends HBoxContainer

@onready var comp_parameter:Label=$label_parameter
@onready var comp_description:Label=$label_description

var parameter:ShaderInfoParameter

func loadParameter(parameter:ShaderInfoParameter)->void:
	self.parameter=parameter
	self.comp_parameter.text=parameter.name + " :"
	self.comp_description.text=parameter.description

