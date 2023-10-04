class_name ShaderInfoParameter
extends Object

var name:String
var description:String
var texture:String

# function to load the parameter values from a json dictionary
#    shaderParameterJson -> the dictionary containing the properties
func loadParameter(shaderParameterJson:Dictionary):
	self.name=shaderParameterJson.name
	self.description=shaderParameterJson.description
	if(shaderParameterJson.has("texture")):
		if(shaderParameterJson.texture.length()>0):
			self.texture=shaderParameterJson.texture

# static function to check whether a specific shader has been downloaded already or not
#  shader -> the shader to check
#  return -> true if the shader has been downloaded, false otherwise
func textureHasBeenDownloaded()->bool:
	if(self.texture!=null && self.texture.length()>0):
		return FileAccess.file_exists("res://addons/sprite-shader-mixer/assets/shaders/"+self.texture)
	return true
