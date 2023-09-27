@tool
extends CenterContainer

var parentSprite

func setParentSprite(parent):
	self.parentSprite=parent;

func _ready():
	if(self.parentSprite is Sprite2D):
		if(self.parentSprite.material != null):
			if(self.parentSprite.material is ShaderMaterial):
				if(self.parentSprite.material.shader != null):
					$create_container.visible=false
					return
	$create_container.visible=true
	$create_container/button_create.pressed.connect(_onCreatePressed)

func _onCreatePressed():
	if(self.parentSprite.material == null):
		self.parentSprite.material=ShaderMaterial.new()
	self.parentSprite.material.shader=Shader.new()
	(self.parentSprite.material.shader as Shader).code="""
	shader_type canvas_item;
	void fragment() {}
	"""
	$create_container.visible=false
	
	
