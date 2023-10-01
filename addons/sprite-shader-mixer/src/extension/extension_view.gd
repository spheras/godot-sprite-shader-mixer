@tool
extends VBoxContainer

@onready var compOptionShaders:OptionButton=$marginContainer/shader_container/HBoxContainer/option_shaders
@onready var compButtonCreate:Button=$marginContainer/create_container/button_create
@onready var compButtonAddShader:Button=$marginContainer/shader_container/HBoxContainer/button_addShader
@onready var compContainerCreate:Control=$marginContainer/create_container
@onready var compContainerShader:Control=$marginContainer/shader_container
var logic:ExtensionLogic=ExtensionLogic.new()

func setParentSprite(parent)->void:
	self.logic.setParentSprite(parent)

func _ready()->void:
	#connecting UI events
	self.compButtonCreate.pressed.connect(logic.onCreatePressed)
	self.compOptionShaders.item_selected.connect(self._onShaderComboSelected)
	self.compButtonAddShader.pressed.connect(self._onAddButtonPressed)

	#connecting logic events
	logic.onCreateContainerVisible.connect(_onCreateContainerVisible)
	logic.onAddShaderButtonVisible.connect(_onAddShadderButtonVisible)
	logic.onShadersAvailable.connect(_onShadersAvailable)
	
	logic.onReady()
	
#-------------------------------------------------------------------
# UI EVENTS
#-------------------------------------------------------------------
# Event produced when a Shader is selected from UI
#   selectedShader -> the selected shader
func _onShaderComboSelected(selectedShaderIndex:int)->void:
	if(selectedShaderIndex>=0):
		var selectedShaderName=self.compOptionShaders.get_item_text(selectedShaderIndex)
		self.logic.shaderSelected(selectedShaderName)

# Event produce when the add button is pressed from UI
func _onAddButtonPressed()->void:
	var selectedShaderName=self.compOptionShaders.get_item_text(self.compOptionShaders.get_selected_id())
	self.logic.onAddShaderPressed(selectedShaderName)

#-------------------------------------------------------------------
# LOGIC EVENTS
#-------------------------------------------------------------------
# Logic Event when shaders are available to be included
#   shaders -> List of shaders which can be selected to be included
func _onShadersAvailable(shaders:Array[ShaderInfo])->void:
	self.compOptionShaders.clear()
	for shader in shaders:
		self.compOptionShaders.add_item(shader.name)

# Logic Event to determine whether the add shader button must be visible
#   visible -> whether the button must be visible
func _onAddShadderButtonVisible(visible:bool)->void:
	self.compButtonAddShader.visible=visible

# Logic Event to determine whether the create container must be visible
#   visible -> whether the container must be visible
func _onCreateContainerVisible(visible:bool)->void:
	self.compContainerCreate.visible=visible
	self.compContainerShader.visible=!visible
	
