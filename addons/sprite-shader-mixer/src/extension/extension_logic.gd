extends Object
class_name ExtensionLogic

signal onCreateContainerVisible(visible:bool)
signal onShadersAvailable(shaders:Array)
var emptyShader = preload("res://addons/sprite-shader-mixer/assets/shaders/empty.gdshader")
#The parent sprite to set the shaders
#It can be a Sprite2D or an AnimatedSprite2D
var parentSprite

func init():
	self._checkCreateVisibility()

func setParentSprite(parent):
	self.parentSprite=parent;

func onCreatePressed():
	#Create button pressed. Creating a new empty Shader.
	if(self.parentSprite.material == null):
		self.parentSprite.material=ShaderMaterial.new()
	self.parentSprite.material.shader=emptyShader
	self._checkCreateVisibility()

func _parentSpriteHasShaderAlready():
	if(self.parentSprite is Sprite2D):
		if(self.parentSprite.material != null):
			if(self.parentSprite.material is ShaderMaterial):
				if(self.parentSprite.material.shader != null):
					return true
	return false

func _checkCreateVisibility():
	#if parent has shader, showing the shaders management
	#else showing create button for an empty shader
	var createButtonVisible=!_parentSpriteHasShaderAlready()
	self.onCreateContainerVisible.emit(createButtonVisible)
	if(!createButtonVisible):
		self._fillShaderCombo()

func _fillShaderCombo():
	var shaders=["Burn","Freeze","Outline","Shadow","Rainbow","Other"]
	self.onShadersAvailable.emit(shaders)
