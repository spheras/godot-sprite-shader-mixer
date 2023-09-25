@tool
@icon("res://addons/sprite-shader-mixer/assets/AnimatedSprite2DShaderMixer.svg")
extends AnimatedSprite2D
class_name AnimatedSprite2DShaderMixer

const SHADER_FOLDER_BASE = "res://addons/godot_sprite_shader/assets/shader/"
const mainShader = preload("res://addons/sprite-shader-mixer/assets/shader.gdshader")

@export_group("Shader Mixer")
@export var shaderMixer:ShaderMixer
	
func _ready():
	if(self.shaderMixer == null):
		print_debug("creamos un shaderMixer")
		var newShaderMixer=ShaderMixer.new()
		shaderMixer=newShaderMixer

	if(self.material == null):
		print_debug("creamos un shaderMaterial")
		var shaderMaterial = ShaderMaterial.new()
		shaderMaterial.shader=self.mainShader;
		self.material=shaderMaterial
