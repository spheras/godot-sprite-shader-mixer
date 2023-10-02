@tool
extends VBoxContainer

@onready var iconDown=preload("res://addons/sprite-shader-mixer/assets/icons/down.svg")
@onready var iconRight=preload("res://addons/sprite-shader-mixer/assets/icons/right.svg")
@onready var shaderInfoContainer = preload("res://addons/sprite-shader-mixer/src/extension/ShaderInfoContainer.tscn")
@onready var compOptionShaders:OptionButton=$marginContainer/shader_container/HBoxContainer/option_shaders
@onready var compButtonCreate:Button=$marginContainer/create_container/button_create
@onready var compButtonAddShader:Button=$marginContainer/shader_container/HBoxContainer/button_addShader
@onready var compContainerCreate:Control=$marginContainer/create_container
@onready var compContainerShader:Control=$marginContainer/shader_container
@onready var compContainerSelectedShaders:Control=$marginContainer/shader_container/shaders_selected_container
@onready var compCurrentShadersTitle:Button=$marginContainer/shader_container/currentShadersTitle
var logic:ExtensionLogic=ExtensionLogic.new()

func setParentSprite(parent)->void:
	self.logic.setParentSprite(parent)

func _ready()->void:
	#connecting UI events
	self.compButtonCreate.pressed.connect(logic.onCreatePressed)
	self.compOptionShaders.item_selected.connect(self._onShaderComboSelected)
	self.compButtonAddShader.pressed.connect(self._onAddButtonPressed)
	self.compCurrentShadersTitle.toggled.connect(self._onShadersButtonToogled)

	#connecting logic events
	logic.onCreateContainerVisible.connect(_onCreateContainerVisible)
	logic.onAddShaderButtonVisible.connect(_onAddShadderButtonVisible)
	logic.onShadersCalculated.connect(_onShadersCalculated)
	
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

func _onShadersButtonToogled(toogled:bool)->void:
	if(toogled):
		compCurrentShadersTitle.icon=self.iconDown
		compContainerSelectedShaders.visible=true
	else:
		compCurrentShadersTitle.icon=self.iconRight
		compContainerSelectedShaders.visible=false

# Event produce when the add button is pressed from UI
func _onAddButtonPressed()->void:
	var selectedShaderName=self.compOptionShaders.get_item_text(self.compOptionShaders.get_selected_id())
	self.logic.onAddShaderPressed(selectedShaderName)

#-------------------------------------------------------------------
# LOGIC EVENTS
#-------------------------------------------------------------------
# Logic Event when shaders are available to be included
#   shaders -> List of shaders which can be selected to be included
func _onShadersCalculated(shadersInserted:Array[ShaderInfo], shadersNotInserted:Array[ShaderInfo])->void:
	self.compOptionShaders.clear()
	for shader in shadersNotInserted:
		self.compOptionShaders.add_item(shader.name)
		
	for child in self.compContainerSelectedShaders.get_children():
		child.queue_free()
	for shader in shadersInserted:
		var newInfoComponent:ShaderInfoContainer=self.shaderInfoContainer.instantiate()	
		self.compContainerSelectedShaders.add_child(newInfoComponent)
		newInfoComponent.loadShaderInfo(shader)
		newInfoComponent.onDeleteShader.connect(self.logic.onDeleteShader)
		newInfoComponent.onReorder.connect(self.logic.onReorder)

# Logic Event to determine whether the add shader button must be visible
#   visible -> whether the button must be visible
func _onAddShadderButtonVisible(visible:bool)->void:
	self.compButtonAddShader.visible=visible

# Logic Event to determine whether the create container must be visible
#   visible -> whether the container must be visible
func _onCreateContainerVisible(visible:bool)->void:
	self.compContainerCreate.visible=visible
	self.compContainerShader.visible=!visible
	
