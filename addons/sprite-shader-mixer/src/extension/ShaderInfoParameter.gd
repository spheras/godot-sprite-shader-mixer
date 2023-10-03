class_name ShaderInfoParameter
extends Object

var name:String
var description:String

func loadParameter(shaderParameterJson:Dictionary):
	self.name=shaderParameterJson.name
	self.description=shaderParameterJson.description
