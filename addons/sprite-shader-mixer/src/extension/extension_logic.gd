class_name ExtensionLogic
extends Object

#SIGNALS
signal onCreateContainerVisible(visible:bool)
signal onAddShaderButtonVisible(visible:bool)
signal onShadersCalculated(shadersInserted:Array[ShaderInfo], shadersNotInserted:Array[ShaderInfo])

#RESOURCES
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
	for shaderToAdd in pendingShaders:
		if(shaderToAdd.name.match(shaderName)):
			self.selectedShaders.append(shaderToAdd)
			self.pendingShaders.erase(shaderToAdd)
			var newShader:Shader=ShaderInfo.generateShaderCode(self.selectedShaders)
			(self.parentSprite.material as ShaderMaterial).shader=newShader
			self._calculateShadersInserted()
			return

# Function called when a shader has been selected
#     shader -> the shader name selected
func shaderSelected(shaderName:String)->void:
	self.onAddShaderButtonVisible.emit(!shaderName.match(NONE_SHADER))

func onReorder(shader:ShaderInfo, after:bool)->void:
	print_debug("reorder")
	var currentIndex=self.selectedShaders.find(shader)
	var flagModified:bool=false
	if(!after && currentIndex>0):
		self.selectedShaders.remove_at(currentIndex)
		self.selectedShaders.insert(currentIndex-1,shader)
		flagModified=true
	elif(after && currentIndex<selectedShaders.size()-1):
		self.selectedShaders.remove_at(currentIndex)
		self.selectedShaders.insert(currentIndex+1,shader)
		flagModified=true
		
	if(flagModified):
		var newShader:Shader=ShaderInfo.generateShaderCode(self.selectedShaders)
		(self.parentSprite.material as ShaderMaterial).shader=newShader
		self._calculateShadersInserted()	
	
func onDeleteShader(shader:ShaderInfo)->void:
	self.selectedShaders.erase(shader)
	self.pendingShaders.append(shader)
	var newShader:Shader=ShaderInfo.generateShaderCode(self.selectedShaders)
	(self.parentSprite.material as ShaderMaterial).shader=newShader
	self._calculateShadersInserted()	

# Function called when the create mixed sprite button
func onCreatePressed()->void:
	#Create button pressed. Creating a new empty Shader.
	if(self.parentSprite.material == null):
		self.parentSprite.material=ShaderMaterial.new()
	self.parentSprite.material.shader=ShaderInfo.generateShaderCode([])
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
		self._calculateShadersInserted()

# Recopile all the shaders available to be added to the
# sprite, those which hasn't been added yet, and emit
# the evento to force the refill of the combo with those shaders
# and the list of inserted shaders
func _calculateShadersInserted()->void:
	#Reading JSON where are defined all available shaders
	ALL_SHADERS=[]
	var allShaders:Array=Util.readJsonFile(SHADERS_JSON_PATH)
	for shaderObj in allShaders:
		var shaderInfo:ShaderInfo=ShaderInfo.new()
		shaderInfo.loadShaderInfo(shaderObj)
		ALL_SHADERS.push_back(shaderInfo)

	#Reading what shaders are currently added to the Sprite
	self.selectedShaders=ShaderInfo.readCurrentlyActiveShadersFromShaderCode(self.parentSprite.material.shader.code, ALL_SHADERS)
	self._calculatePendingShaders()
	self.onShadersCalculated.emit(self.selectedShaders, self.pendingShaders)

# Calculates the pending shaders to be added
# based on the shaders already added
func _calculatePendingShaders()->void:
	self.pendingShaders=[]
	for shader in ALL_SHADERS:
		if(self.selectedShaders.find(shader)<0):
			self.pendingShaders.append(shader)
