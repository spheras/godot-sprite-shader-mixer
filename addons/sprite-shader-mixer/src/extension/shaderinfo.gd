class_name ShaderInfo
extends Object

const SHADERS_BASE_PATH="res://addons/sprite-shader-mixer/assets/shaders/"
const EMPTY_SHADER_FILE_PATH="res://addons/sprite-shader-mixer/assets/shaders/empty.gdshader"
const EMPTY_SHADER_VARIABLE_SHADERS="%SHADERS%"
const EMPTY_SHADER_VARIABLE_FUNCTIONS="//%FUNCTIONS%"
const EMPTY_SHADER_VARIABLE_CALLS="//%CALLS%"
const SHADERS_COMMENT="//SHADERS:"

var name:String #name of the shader
var group:String #group of the shader
var description:String #description of the shader
var author:String #original author of the shader
var adaptedBy:String #who mades the adaptation to the plugin
var link:String #link to the original shader/author/...
var license:String #license of the original shader
var version:String #version of the adaptation
var filename:String #filename where is located the shader
var activation:String #activation uniform variable name
var function:String #main function of the shader to be called
var parameters:Array[ShaderInfoParameter] #List of parameters of the shader

# Load a shader info values from a json dictionary
#   shaderInfoJsonObject the object readed from a json, converted in a dictionary
func loadShaderInfo(shaderInfoJsonObject:Dictionary):
	self.name=shaderInfoJsonObject.name
	self.group=shaderInfoJsonObject.group
	self.description=shaderInfoJsonObject.description
	self.author=shaderInfoJsonObject.author
	self.version=shaderInfoJsonObject.version
	self.filename=shaderInfoJsonObject.filename
	self.activation=shaderInfoJsonObject.activation
	self.function=shaderInfoJsonObject.function
	self.link=shaderInfoJsonObject.link
	self.adaptedBy=shaderInfoJsonObject.adaptedBy
	self.license=shaderInfoJsonObject.license
	for param in shaderInfoJsonObject.parameters:
		var shaderInfoParameter:ShaderInfoParameter=ShaderInfoParameter.new()
		shaderInfoParameter.loadParameter(param)
		self.parameters.push_back(shaderInfoParameter)	

# static function to read the currently active shaders from the shader script
#  selectedShadersCode -> the shader code to read
#  allShaders -> the list of all shaders available
#  return -> the list of currently shaders inside the shader code
static func readCurrentlyActiveShadersFromShaderCode(selectedShadersCode:String, allShaders:Array[ShaderInfo])->Array[ShaderInfo]:
	var lines:PackedStringArray=selectedShadersCode.split("\n")
	var result:Array[ShaderInfo]=[]
	for line in lines:
		var lineTrimmed=(line as String).trim_prefix(" ")
		if (lineTrimmed.begins_with(SHADERS_COMMENT)):
			var includedShadersName=lineTrimmed.substr(SHADERS_COMMENT.length()).split(",")
			for includedShaderName in includedShadersName:
				var shaderInfo=_searchShaderWithName(includedShaderName,allShaders)
				if(shaderInfo!=null):
					result.append(shaderInfo)
			return result
	return result

# private static function to find a ShaderInfo object from the array with a certain name
#   shaderName -> the name to search
#   allShaders -> the array of shaders where the algorithm must search
#   return -> the ShaderInfo object found or null otherwise
static func _searchShaderWithName(shaderName:String, allShaders:Array[ShaderInfo]) -> ShaderInfo:
	for shader in allShaders:
		if(shader.name.match(shaderName)):
			return shader
	return null

# private static function to replace variables inside the empty shader. Those variables are
# relatives to the list of shaders, the functions, the calls...  converting the empty shader
# in a valid full shader with the selected shaders
#   shaders: the list of shaders included in the code
#   functions: the code of the shaders
#   calls: the calls to the shaders
#   return-> the final shader code with all merged
static func _replaceScriptVariables(shaders:String, functions:String, calls:String)->String:
	var contentOfEmptyShader=Util.readFile(EMPTY_SHADER_FILE_PATH)
	contentOfEmptyShader=contentOfEmptyShader.replace(EMPTY_SHADER_VARIABLE_SHADERS,shaders)
	contentOfEmptyShader=contentOfEmptyShader.replace(EMPTY_SHADER_VARIABLE_FUNCTIONS,functions)
	contentOfEmptyShader=contentOfEmptyShader.replace(EMPTY_SHADER_VARIABLE_CALLS,calls)
	return contentOfEmptyShader

# static function to check whether a specific shader has been downloaded already or not
#  shader -> the shader to check
#  return -> true if the shader has been downloaded, false otherwise
static func shaderHasBeenDownloaded(shader:ShaderInfo)->bool:
	return FileAccess.file_exists("res://addons/sprite-shader-mixer/assets/shaders/"+shader.filename)

# static function to generate a shader code based on the selected shaders to incorporate.
#   selectedShaders -> a list of selected shaders to generate the shader code
#   return -> the shader object generated with the code inside
static func generateShaderCode(selectedShaders:Array[ShaderInfo])->Shader:
	var functionsCode:String=""
	for selectedShader in selectedShaders:
		var contentOfSelectedShader=Util.readFile(SHADERS_BASE_PATH+selectedShader.filename)
		functionsCode=functionsCode+"\n"+contentOfSelectedShader
		
	var shadersCode=""
	for selectedShader in selectedShaders:
		shadersCode=shadersCode + selectedShader.name + ","

	var callsCode=""
	for selectedShader in selectedShaders:
		callsCode=callsCode+"\tif("+selectedShader.activation+") "+selectedShader.function+"(UV, TEXTURE, size, TEXTURE_PIXEL_SIZE, color);\n"

	var shaderCode=_replaceScriptVariables(shadersCode, functionsCode, callsCode)
	var shader=Shader.new()
	shader.code=shaderCode
	return shader
