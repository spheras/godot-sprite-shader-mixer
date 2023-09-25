@tool
extends Resource
class_name ShaderMixer

@export_group("Greyscale")
@export var greyscale:bool=false: set = _setGreyscale
@export var greyscale_tintColor:Color: set = _setGreyscaleTintColor
@export_range(-1.0, 1.0) var greyscale_luminosity : float = 0.0: set = _setGreyscaleLuminosity
@export_range(0.0,1.0) var greyscale_blend : float = 1.0: set = _setGreyscaleBlend

@export_group("Outline")
@export var outline:bool=false: set = _setOutline
@export var outline_width:int=2: set = _setOutlineWidth
@export var outline_color : Color: set = _setOutlineColor

@export_group("Test")
@export var test:bool=false: set = _setTest

var parentSprite

func _changeSpriteShaderParameter(parameter, value):
	if(self.parentSprite != null) :
		(self.parentSprite.material as ShaderMaterial).set_shader_parameter(parameter, value)

func setParentSprite(sprite):
	self.parentSprite=sprite

func _setGreyscale(_greyscale):
	greyscale=_greyscale
	_changeSpriteShaderParameter("GREYSCALE_active",_greyscale)

func _setGreyscaleTintColor(tintColor):
	greyscale_tintColor=tintColor
	_changeSpriteShaderParameter("GREYSCALE_TintColor",tintColor)

func _setGreyscaleLuminosity(luminosity):
	greyscale_luminosity=luminosity
	_changeSpriteShaderParameter("GREYSCALE_Luminosity",luminosity)

func _setGreyscaleBlend(blend):
	greyscale_blend=blend
	_changeSpriteShaderParameter("GREYSCALE_Blend",blend)
	
func _setOutline(_outline):
	outline=_outline
	_changeSpriteShaderParameter("OUTLINE_active",_outline)
	
func _setOutlineWidth(_outlineWidth):
	outline_width=_outlineWidth
	_changeSpriteShaderParameter("OUTLINE_width",float(_outlineWidth))

func _setOutlineColor(_outlineColor):
	outline_color=_outlineColor
	_changeSpriteShaderParameter("OUTLINE_color", _outlineColor)

func _setTest(_test):
	test=_test
	_changeSpriteShaderParameter("TEST_active",_test)
