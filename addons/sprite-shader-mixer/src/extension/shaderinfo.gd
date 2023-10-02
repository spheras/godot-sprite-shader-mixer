class_name ShaderInfo
extends Object

const EMPTY_SHADER_FILE_PATH="res://addons/sprite-shader-mixer/assets/shaders/empty.gdshader"
const EMPTY_SHADER_VARIABLE_SHADERS="%SHADERS%"
const EMPTY_SHADER_VARIABLE_FUNCTIONS="//%FUNCTIONS%"
const EMPTY_SHADER_VARIABLE_CALLS="//%CALLS%"
const SHADERS_COMMENT="//SHADERS:"

var name:String
var group:String
var description:String
var author:String
var version:String
var filename:String
var activation:String
var function:String

func loadShaderInfo(shaderInfoJsonObject:Dictionary):
	self.name=shaderInfoJsonObject.name
	self.group=shaderInfoJsonObject.group
	self.description=shaderInfoJsonObject.description
	self.author=shaderInfoJsonObject.author
	self.version=shaderInfoJsonObject.version
	self.filename=shaderInfoJsonObject.filename
	self.activation=shaderInfoJsonObject.activation
	self.function=shaderInfoJsonObject.function

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


static func _searchShaderWithName(shaderName:String, allShaders:Array[ShaderInfo]) -> ShaderInfo:
	for shader in allShaders:
		if(shader.name.match(shaderName)):
			return shader
	return null

static func _replaceScriptVariables(shaders:String, functions:String, calls:String)->String:
	var contentOfEmptyShader=Util.readFile(EMPTY_SHADER_FILE_PATH)
	contentOfEmptyShader=contentOfEmptyShader.replace(EMPTY_SHADER_VARIABLE_SHADERS,shaders)
	contentOfEmptyShader=contentOfEmptyShader.replace(EMPTY_SHADER_VARIABLE_FUNCTIONS,functions)
	contentOfEmptyShader=contentOfEmptyShader.replace(EMPTY_SHADER_VARIABLE_CALLS,calls)
	return contentOfEmptyShader

static func generateShaderCode(selectedShaders:Array[ShaderInfo])->Shader:
	var functionsCode:String=""
	for selectedShader in selectedShaders:
		var contentOfSelectedShader=Util.readFile("res://addons/sprite-shader-mixer/assets/shaders/"+selectedShader.filename)
		functionsCode=functionsCode+"\n"+contentOfSelectedShader
		
	var shadersCode=""
	for selectedShader in selectedShaders:
		shadersCode=shadersCode + selectedShader.name + ","

	var callsCode=""
	for selectedShader in selectedShaders:
		callsCode=callsCode+"\tif("+selectedShader.activation+") "+selectedShader.function+"(UV, TEXTURE, TEXTURE_PIXEL_SIZE, color);\n"

	var shaderCode=_replaceScriptVariables(shadersCode, functionsCode, callsCode)
	var shader=Shader.new()
	shader.code=shaderCode
	return shader
