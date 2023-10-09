class_name ShaderInfo
extends Object

const SHADERS_BASE_PATH="res://addons/sprite-shader-mixer/assets/shaders/"
const EMPTY_SHADER_FILE_PATH="res://addons/sprite-shader-mixer/assets/shaders/empty.gdshader"
const EMPTY_SHADER_VARIABLE_SHADERS="%SHADERS%"
const EMPTY_SHADER_VARIABLE_FUNCTIONS="//%FUNCTIONS%"
const EMPTY_SHADER_VARIABLE_FRAGMENT_CALLS="//%CALLS%"
const EMPTY_SHADER_VARIABLE_VERTEX_CALLS="//%VERTEX_CALLS%"
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
var customCall:String #Optional, custom call from fragment, list of parameters
var vertex:bool=false #indicates if the shader has vertex functions
var vertexCallCode:String #Optional, in case there is a vertex code, we need the vertex code to add to the vertex function, like calling functions and setting initial values to varying variables
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
	self.link=shaderInfoJsonObject.link
	self.adaptedBy=shaderInfoJsonObject.adaptedBy
	self.license=shaderInfoJsonObject.license
	
	self.function=shaderInfoJsonObject.function
	if(shaderInfoJsonObject.has("customCall")):
		if(shaderInfoJsonObject.customCall.length()>0):
			self.customCall=shaderInfoJsonObject.customCall
			
	for param in shaderInfoJsonObject.parameters:
		var shaderInfoParameter:ShaderInfoParameter=ShaderInfoParameter.new()
		shaderInfoParameter.loadParameter(param)
		self.parameters.push_back(shaderInfoParameter)	

	if(shaderInfoJsonObject.has("vertex")):
		self.vertex=shaderInfoJsonObject.vertex

	if(shaderInfoJsonObject.has("vertexCallCode")):
		if(shaderInfoJsonObject.vertexCallCode.length()>0):
			self.vertexCallCode=shaderInfoJsonObject.vertexCallCode

# delete this shader phisically and the textures associated
func delete():
	if(shaderHasBeenDownloaded(self)):
		#delete the gdshader script
		Util.deleteFile(SHADERS_BASE_PATH+self.filename)
		#delete if necessary the texture images
		for param in self.parameters:
			if(param.texture!=null && param.texture.length()>0):
				var texturePath=SHADERS_BASE_PATH+param.texture
				Util.deleteFile(texturePath)
		
		#delete if neccesary the vertex code
		if(vertex && self.vertexCallCode):
			var vertexPath=SHADERS_BASE_PATH+self.vertexCallCode
			Util.deleteFile(vertexPath)
		
		OS.alert("Shader Removed, you can download again if necessary. See you!")

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
#   calls: the calls to the shaders from fragment
#   vertexCall: the call to the shaders from the vertex
#   return-> the final shader code with all merged
static func _replaceScriptVariables(shaders:String, functions:String, calls:String, vertexCalls:String)->String:
	var contentOfEmptyShader=Util.readFile(EMPTY_SHADER_FILE_PATH)
	contentOfEmptyShader=contentOfEmptyShader.replace(EMPTY_SHADER_VARIABLE_SHADERS,shaders)
	contentOfEmptyShader=contentOfEmptyShader.replace(EMPTY_SHADER_VARIABLE_FUNCTIONS,functions)
	contentOfEmptyShader=contentOfEmptyShader.replace(EMPTY_SHADER_VARIABLE_FRAGMENT_CALLS,calls)
	contentOfEmptyShader=contentOfEmptyShader.replace(EMPTY_SHADER_VARIABLE_VERTEX_CALLS,vertexCalls)
	return contentOfEmptyShader

# static function to check whether a specific shader has been downloaded already or not
#  shader -> the shader to check
#  return -> true if the shader has been downloaded, false otherwise
static func shaderHasBeenDownloaded(shader:ShaderInfo)->bool:
	return FileAccess.file_exists(SHADERS_BASE_PATH+shader.filename)

# static function to generate a shader code based on the selected shaders to incorporate.
#   selectedShaders -> a list of selected shaders to generate the shader code
#   return -> the shader object generated with the code inside
static func generateShaderCode(selectedShaders:Array[ShaderInfo])->Shader:
	var functionsCode:String=""
	for selectedShader in selectedShaders:
		#fragment functions
		var contentOfSelectedShader=Util.readFile(SHADERS_BASE_PATH+selectedShader.filename)
		functionsCode=functionsCode+"\n"+contentOfSelectedShader
				
	var shadersCode=""
	for selectedShader in selectedShaders:
		shadersCode=shadersCode + selectedShader.name + ","

	var callsCode=""
	for selectedShader in selectedShaders:
		var parameters="uv, TEXTURE, size, TEXTURE_PIXEL_SIZE, color";
		if(selectedShader.customCall!=null && selectedShader.customCall.length()>0):
			parameters=selectedShader.customCall;
		callsCode=callsCode+"\tif("+selectedShader.activation+") "+selectedShader.function+"("+parameters+");\n"

	var vertexCode=""
	for selectedShader in selectedShaders:
		if(selectedShader.vertex && selectedShader.vertexCallCode!=null  && selectedShader.vertexCallCode.length()>0):
			var vertexCodeOfSelectedShader=Util.readFile(SHADERS_BASE_PATH+selectedShader.vertexCallCode)
			vertexCode=vertexCode+"\n"+vertexCodeOfSelectedShader
	

	var shaderCode=_replaceScriptVariables(shadersCode, functionsCode, callsCode, vertexCode)
	var shader=Shader.new()
	shader.code=shaderCode
	return shader


