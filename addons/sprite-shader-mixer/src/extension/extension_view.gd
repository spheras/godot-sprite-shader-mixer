@tool
extends VBoxContainer

var logic:ExtensionLogic=ExtensionLogic.new()

func setParentSprite(parent):
	self.logic.setParentSprite(parent)

func _ready():
	$marginContainer/create_container/button_create.pressed.connect(logic.onCreatePressed)
	$marginContainer/shader_container/HBoxContainer/option_shaders.item_selected.connect(self._onShaderComboSelected)
	logic.onCreateContainerVisible.connect(_onCreateContainerVisible)
	logic.onShadersAvailable.connect(_onShadersAvailable)
	logic.init()

func _onShaderComboSelected(selectedShader):
	$marginContainer/shader_container/HBoxContainer/button_addShader.disabled=false

func _onShadersAvailable(shaders:Array):
	var optionShaders=$marginContainer/shader_container/HBoxContainer/option_shaders
	optionShaders.clear()
	for shader in shaders:
		optionShaders.add_item(shader)
		
func _onCreateContainerVisible(visible:bool):
	$marginContainer/create_container.visible=visible
	$marginContainer/shader_container.visible=!visible
	
