@tool
class_name ExtensionView
extends VBoxContainer

@onready var managerWindow=preload("res://addons/sprite-shader-mixer/src/extension/searchform/searchform.tscn")
@onready var iconDown=preload("res://addons/sprite-shader-mixer/assets/icons/down.svg")
@onready var iconRight=preload("res://addons/sprite-shader-mixer/assets/icons/right.svg")
@onready var shaderInfoContainer = preload("res://addons/sprite-shader-mixer/src/extension/shaderinfo/ShaderInfoContainer.tscn")
@onready var compOptionShaders:OptionButton=$marginContainer/shader_container/HBoxContainer/option_shaders
@onready var compButtonCreate:Button=$marginContainer/create_container/button_create
@onready var compButtonAddShader:Button=$marginContainer/shader_container/HBoxContainer/button_addShader
@onready var compContainerCreate:Control=$marginContainer/create_container
@onready var compContainerShader:Control=$marginContainer/shader_container
@onready var compContainerSelectedShaders:Control=$marginContainer/shader_container/shaders_selected_container
@onready var compCurrentShadersTitle:Button=$marginContainer/shader_container/currentShadersTitle
@onready var compButtonDownload:Button=$marginContainer/shader_container/HBoxContainer/button_download
@onready var compButtonSync:Button=$marginContainer/shader_container/HBoxContainer/button_sync
@onready var compButtonManager:Button=$marginContainer/shader_container/HBoxContainer/button_manager

var logic:ExtensionLogic=ExtensionLogic.new()

func setParentSprite(parent)->void:
	self.logic.setParentSprite(parent)

func _ready()->void:
	#connecting UI events
	self.compButtonCreate.pressed.connect(self.logic.onCreatePressed)
	self.compOptionShaders.item_selected.connect(self._onShaderComboSelected)
	self.compButtonAddShader.pressed.connect(self._onAddButtonPressed)
	self.compCurrentShadersTitle.toggled.connect(self._onShadersButtonToogled)
	self.compButtonDownload.pressed.connect(self._onDownloadPressed)
	self.compButtonSync.pressed.connect(self._onSyncShaderList)
	self.compButtonManager.pressed.connect(self._onShowManager)

	#connecting logic events
	logic.onCreateContainerVisible.connect(_onCreateContainerVisible)
	logic.onAddShaderButtonVisible.connect(_onAddShadderButtonVisible)
	logic.onDownloadButtonVisible.connect(_onDownloadButtonVisible)
	logic.onSyncButtonVisible.connect(_onSyncButtonVisible)
	logic.onShadersCalculated.connect(_onShadersCalculated)
	
	logic.onReady()

#-------------------------------------------------------------------
# UI EVENTS
#-------------------------------------------------------------------
var manager:Window

func _onShowManager():
	if(self.manager!=null):
		self.manager.queue_free()
		
	self.manager=self.managerWindow.instantiate()
	self.add_child(manager)
	manager.close_requested.connect(_onCloseManager);
	manager.setShaders(self.logic.pendingShaders, self.logic)
	manager.shaderSelected.connect(_onManagerShaderSelected)

func _onManagerShaderSelected(shader:ShaderInfo):
	for  i in range(self.logic.pendingShaders.size()):
		var iShader=self.logic.pendingShaders[i]
		if(iShader.name==shader.name):
			self.compOptionShaders.select(i+1)
			self._onShaderComboSelected(i+1)
	manager.queue_free()
	self.manager=null

func _onCloseManager():
	manager.queue_free()
	manager=null

# Event produced when a Shader is selected from UI
#   selectedShader -> the selected shader
func _onShaderComboSelected(selectedShaderIndex:int)->void:
	if(selectedShaderIndex>=0):
		var selectedShaderName=self.compOptionShaders.get_item_text(selectedShaderIndex)
		self.logic.shaderSelected(selectedShaderName)

func _onSyncShaderList()->void:
	var oldText=self.compButtonSync.text
	self.compButtonSync.text="Loading..(wait)"
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	self.logic.onSyncShaderList()
	self.compButtonSync.text=oldText

func _onShadersButtonToogled(toogled:bool)->void:
	if(toogled):
		compCurrentShadersTitle.icon=self.iconDown
		compContainerSelectedShaders.visible=true
	else:
		compCurrentShadersTitle.icon=self.iconRight
		compContainerSelectedShaders.visible=false

func _onDownloadPressed()->void:
	var oldText=self.compButtonDownload.text
	self.compButtonDownload.text="Loading..(wait)"
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	var selectedShaderName=self.compOptionShaders.get_item_text(self.compOptionShaders.get_selected_id())
	self.logic.onDownloadShaderPressed(selectedShaderName, self)
	self.compButtonDownload.text=oldText

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
	self.compOptionShaders.add_item("None")
	for shader in shadersNotInserted:
		self.compOptionShaders.add_item(shader.name)
		
	for child in self.compContainerSelectedShaders.get_children():
		child.queue_free()
	for shader in shadersInserted:
		var newInfoComponent:ShaderInfoContainer=self.shaderInfoContainer.instantiate()	
		self.compContainerSelectedShaders.add_child(newInfoComponent)
		newInfoComponent.loadShaderInfo(shader)
		newInfoComponent.onDeleteShader.connect(self.logic.onDeleteShader)
		newInfoComponent.onQuitShader.connect(self.logic.onQuitShader)
		newInfoComponent.onReorder.connect(self.logic.onReorder)
	
	self.compCurrentShadersTitle.text="List of Current Shaders (%s)"%shadersInserted.size()

# Logic Event to determine whether the add shader button must be visible
#   visible -> whether the button must be visible
func _onAddShadderButtonVisible(visible:bool)->void:
	self.compButtonAddShader.visible=visible

# Logic Event to determine whether the download button must be visible
#   visible -> whether the button must be visible
func _onDownloadButtonVisible(visible:bool)->void:
	self.compButtonDownload.visible=visible

# Logic Event to determine whether the sync button must be visible
#   visible -> whether the button must be visible
func _onSyncButtonVisible(visible:bool)->void:
	self.compButtonSync.visible=visible

# Logic Event to determine whether the create container must be visible
#   visible -> whether the container must be visible
func _onCreateContainerVisible(visible:bool)->void:
	self.compContainerCreate.visible=visible
	self.compContainerShader.visible=!visible
	
