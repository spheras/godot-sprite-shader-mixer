@tool
@icon("res://addons/sprite-shader-mixer/assets/Sprite2DShaderMixer.svg")
extends Sprite2D
class_name Sprite2DShaderMixer

const SHADER_FOLDER_BASE = "res://addons/godot_sprite_shader/assets/shader/"
const mainShader = preload("res://addons/sprite-shader-mixer/assets/shader.gdshader")

@export_group("Shader Mixer")
@export var shaderMixer:ShaderMixer: set = _onSetShaderMixer

func _onSetShaderMixer(_shaderMixer):
	shaderMixer=_shaderMixer
	shaderMixer.setParentSprite(self)

func _ready():
	print_debug("ready")

	if(self.shaderMixer == null):
		var newShaderMixer=ShaderMixer.new()
		shaderMixer=newShaderMixer

	if(self.material == null):
		var shaderMaterial = ShaderMaterial.new()
		shaderMaterial.shader=self.mainShader;
		self.material=shaderMaterial

	self.shaderMixer.setParentSprite(self)
