@tool
@icon("res://addons/sprite-shader-mixer/assets/AnimatedSprite2DShaderMixer.svg")
extends AnimatedSprite2D
class_name AnimatedSprite2DShaderMixer

const mainShader = preload("res://addons/sprite-shader-mixer/assets/shader.gdshader")
@export_group("Shader Mixer")
@export var shaderMixer:ShaderMixer: set = _onSetShaderMixer

func _onSetShaderMixer(_shaderMixer):
	shaderMixer=_shaderMixer
	shaderMixer.setParentSprite(self)
	_checkShaderMixer()

func _checkShaderMixer():
	if(self.shaderMixer == null):
		var newShaderMixer=ShaderMixer.new()
		shaderMixer=newShaderMixer

	if(self.material == null):
		var shaderMaterial = ShaderMaterial.new()
		shaderMaterial.shader=self.mainShader;
		self.material=shaderMaterial

	self.shaderMixer.setParentSprite(self)
	
func _ready():
	_checkShaderMixer()
