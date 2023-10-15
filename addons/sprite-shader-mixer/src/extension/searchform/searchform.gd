@tool
extends Window

signal shaderSelected(shader:ShaderInfo)

@onready var tree:Tree = %tree
@onready var option:OptionButton = %option_group
@onready var panel_right = %panel_right
@onready var text_author = %text_author
@onready var text_adaptedby = %text_adaptedby
@onready var text_link = %text_link
@onready var text_license = %text_license
@onready var text_version = %text_version
@onready var text_description = %text_description
@onready var tab = %tab
@onready var panel_info = %panel_info
@onready var panel_example = %panel_example
@onready var button_select:Button = %button_select

var shaders:Array[ShaderInfo];

func _ready():
	panel_right.visible=false;
	tree.cell_selected.connect(_onShaderSelected)
	tab.tab_selected.connect(_onTabSelected)
	button_select.disabled=true
	button_select.pressed.connect(_onButtonSelected)

func _onButtonSelected():
	var shaderName=tree.get_selected().get_text(0)
	var shader:ShaderInfo=_findShaderByName(shaderName)
	self.shaderSelected.emit(shader)
	
func _onTabSelected(tab:int):
	if(tab==0):
		panel_info.visible=true
		panel_example.visible=false
	else:
		panel_info.visible=false
		panel_example.visible=true
	
func _onShaderSelected():
	var treeItem:TreeItem=tree.get_selected()
	var text=treeItem.get_text(0)
	var shader=_findShaderByName(text)
	if(shader!=null):
		_fillShaderInfo(shader)
		panel_right.visible=true;
		button_select.disabled=false;
	else:
		panel_right.visible=false;
		button_select.disabled=true;

func _fillShaderInfo(shader:ShaderInfo):
	text_author.text=shader.name
	text_adaptedby.text=shader.adaptedBy
	text_description.text=shader.description
	text_license.text=shader.license
	text_version.text=shader.version
	text_link.text=shader.link
	
func _findShaderByName(name:String):
	for shader in self.shaders:
		if(shader.name==name):
			return shader
	return null

func setShaders(shaders:Array[ShaderInfo]):
	self.shaders=shaders;
	var allItem:TreeItem=tree.create_item();
	allItem.set_text(0,"All Shaders")
	var groups=self.getGroups(shaders)
	for group in groups:
		self.option.add_item(group)
		var item:TreeItem=tree.create_item(allItem);
		item.set_text(0,group)
		var shadersOfGroup=getShaderOfGroup(shaders, group)
		for shader in shaders:
			var treeShader=tree.create_item(item)
			treeShader.set_text(0,shader.name)

func getShaderOfGroup(shaders:Array[ShaderInfo], group:String):
	var result:Array[ShaderInfo]=[]
	for shader in shaders:
		if(shader.group == group):
			result.append(shader)
	return result

func getGroups(shaders:Array[ShaderInfo]):
	var groups:Array[String]=[]
	for shader in shaders:
		if(groups.find(shader.group)<0):
			groups.append(shader.group)
	return groups	
