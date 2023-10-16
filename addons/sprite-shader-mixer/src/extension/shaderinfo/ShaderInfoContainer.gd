@tool
class_name ShaderInfoContainer
extends VBoxContainer


signal onDeleteShader(shaderInfo:ShaderInfo)
signal onQuitShader(shaderInfo:ShaderInfo)
signal onReorder(shaderInfo:ShaderInfo,after:bool)

@onready var right_icon = preload("res://addons/sprite-shader-mixer/assets/icons/right.svg")
@onready var down_icon = preload("res://addons/sprite-shader-mixer/assets/icons/down.svg")
@onready var shaderInfoParameterContainer = preload("res://addons/sprite-shader-mixer/src/extension/shaderinfo/parameter/ShaderInfoParameterContainer.tscn")
@onready var comp_name:Label=$container_name/container_title/container_name_separator/label_name
@onready var comp_quit:Button=$container_name/remove_container/button_quit
@onready var comp_delete:Button=$container_name/remove_container/button_delete
@onready var comp_author:Label=$container_author/text_author
@onready var comp_link:Label=$container_link/text_link
@onready var comp_adaptedby:Label=$container_adaptedby/text_adaptedby
@onready var comp_license:Label=$container_license/text_license
@onready var comp_version:Label=$container_version/text_version
@onready var comp_description:Label=$container_description/text_description
@onready var comp_buttonUp:Button=$container_name/container_title/container_updown/button_up
@onready var comp_buttonDown:Button=$container_name/container_title/container_updown/button_down
@onready var comp_buttonParameters:Button=$container_parameters/button_parameters
@onready var comp_parameters_container_inside:VBoxContainer=$container_parameters/container_parameters_inside

var shaderInfo:ShaderInfo

func _ready():
	(comp_link as Label).gui_input.connect(_onLinkInput)

func _onLinkInput(event:InputEvent):
	if (event is InputEventMouseButton && 
		event.pressed && 
		event.button_index == 1):
		OS.shell_open(comp_link.text)

func loadShaderInfo(shaderInfo:ShaderInfo)->void:
	comp_name.text=shaderInfo.name
	comp_author.text=shaderInfo.author
	comp_version.text=shaderInfo.version
	comp_description.text=shaderInfo.description
	comp_link.text=shaderInfo.link
	comp_adaptedby.text=shaderInfo.adaptedBy
	comp_license.text=shaderInfo.license
	self.comp_delete.pressed.connect(self._onDeleteButtonPressed)
	self.comp_quit.pressed.connect(self._onQuitButtonPressed)
	self.comp_buttonUp.pressed.connect(self._onButtonUp)
	self.comp_buttonDown.pressed.connect(self._onButtonDown)
	self.comp_buttonParameters.toggled.connect(self._onParametersButtonToggled)
	self.shaderInfo=shaderInfo
	self.comp_parameters_container_inside.visible=false
	for parameter in shaderInfo.parameters:
		var newParameterComponent:ShaderInfoParameterContainer=self.shaderInfoParameterContainer.instantiate()
		self.comp_parameters_container_inside.add_child(newParameterComponent)
		await get_tree().process_frame
		newParameterComponent.loadParameter(parameter)

func _onParametersButtonToggled(pressed:bool):
	self.comp_parameters_container_inside.visible=pressed
	if(pressed):
		self.comp_buttonParameters.icon=down_icon
	else:
		self.comp_buttonParameters.icon=right_icon

func _onButtonUp():
	self.onReorder.emit(self.shaderInfo, false)

func _onButtonDown():
	self.onReorder.emit(self.shaderInfo, true)

func _onDeleteButtonPressed():
	var confirmation=ConfirmationDialog.new()
	confirmation.min_size=Vector2(400,100)
	confirmation.position=Vector2(100,100)
	confirmation.title="Delete Shader"
	confirmation.dialog_autowrap=true
	confirmation.dialog_text="Deletion means that the downloaded shader will be removed from local and from the shader script.  You can download again if necesary, but this will remove the scripts and the textures from your local project."
	confirmation.get_ok_button().pressed.connect(func (): self.onDeleteShader.emit(self.shaderInfo))	
	add_child(confirmation)
	confirmation.show()
	
func _onQuitButtonPressed():
	self.onQuitShader.emit(self.shaderInfo)
