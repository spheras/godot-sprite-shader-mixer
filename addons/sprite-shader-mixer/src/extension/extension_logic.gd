class_name ExtensionLogic
extends Object

#SIGNALS
signal onCreateContainerVisible(visible:bool)
signal onAddShaderButtonVisible(visible:bool)
signal onShadersAvailable(shaders:Array[ShaderInfo])

#RESOURCES
var emptyShader = load("res://addons/sprite-shader-mixer/assets/shaders/empty.gdshader")
const SHADERS_JSON_PATH="res://addons/sprite-shader-mixer/assets/shaders/shaders.json"

#PROPERTIES
var parentSprite #The parent sprite to set the shaders. It can be a Sprite2D or an AnimatedSprite2D
const NONE_SHADER:String="None"
var ALL_SHADERS:Array[ShaderInfo]=[] #list of all available shaders
var selectedShaders:Array[ShaderInfo]=[] #list of selected shaders in the sprite
var pendingShaders:Array[ShaderInfo]=[] #list of pending available shaders


func onReady():
	self._checkCreateVisibility()

# Set the parent which is owner of the shader to manipulate
#     parent -> Sprite2D or AnimationSprite2D
func setParentSprite(parent)->void:
	assert(parent is Sprite2D || parent is AnimatedSprite2D)
	self.parentSprite=parent;
	self._checkCreateVisibility()

# Function called when a shader is intended to be added
#    shader -> the shader name to be added
func onAddShaderPressed(shaderName:String)->void:
	self.selectedShaders.append(shaderName)
	self.pendingShaders.erase(shaderName)
	var newCode=ShaderInfo.generateShaderCode(self.selectedShaders)
	(self.parentSprite.material as ShaderMaterial).shader.code=newCode
	self._fillShaderCombo()

# Function called when a shader has been selected
#     shader -> the shader name selected
func shaderSelected(shaderName:String)->void:
	self.onAddShaderButtonVisible.emit(!shaderName.match(NONE_SHADER))

# Function called when the create mixed sprite button
func onCreatePressed()->void:
	#Create button pressed. Creating a new empty Shader.
	if(self.parentSprite.material == null):
		self.parentSprite.material=ShaderMaterial.new()
	self.parentSprite.material.shader=emptyShader
	self._checkCreateVisibility()

# Checks if the parent Sprite has a shader already configured
# return -> true if the parent has a shader alredy, false otherwise
func _parentSpriteHasShaderAlready()->bool:
	if(self.parentSprite is Sprite2D):
		if(self.parentSprite.material != null):
			if(self.parentSprite.material is ShaderMaterial):
				if(self.parentSprite.material.shader != null):
					return true
	return false

# Check if the create button must be visible, 
# and launch the event if necessary
func _checkCreateVisibility()->void:
	#if parent has shader, showing the shaders management
	#else showing create button for an empty shader
	var createButtonVisible=!_parentSpriteHasShaderAlready()
	self.onCreateContainerVisible.emit(createButtonVisible)
	if(!createButtonVisible):
		self._fillShaderCombo()

# Recopile all the shaders available to be added to the
# sprite, those which hasn't been added yet, and emit
# the evento to force the refill of the combo with those shaders
func _fillShaderCombo()->void:

	#Reading JSON where are defined all available shaders
	var allShaders:Array=Util.readJsonFile(SHADERS_JSON_PATH)
	for shaderObj in allShaders:
		var shaderInfo:ShaderInfo=ShaderInfo.new()
		shaderInfo.loadShaderInfo(shaderObj)
		ALL_SHADERS.push_back(shaderInfo)

	#Reading what shaders are currently added to the Sprite
	self.selectedShaders=ShaderInfo.readCurrentlyActiveShadersFromShaderCode(self.parentSprite.material.shader.code, ALL_SHADERS)
	self._calculatePendingShaders()
	self.onShadersAvailable.emit(self.pendingShaders)

# Calculates the pending shaders to be added
# based on the shaders already added
func _calculatePendingShaders()->void:
	self.pendingShaders=[]
	for shader in ALL_SHADERS:
		if(self.selectedShaders.find(shader)<0):
			self.pendingShaders.append(shader)

