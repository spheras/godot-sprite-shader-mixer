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
@onready var edit_search = %edit_search
@onready var button_download = %button_download

var allShaders:Array[ShaderInfo];
var shaders:Array[ShaderInfo];
var logic:ExtensionLogic;

func _ready():
	panel_right.visible=false;
	tree.cell_selected.connect(_onShaderSelected)
	tab.tab_selected.connect(_onTabSelected)
	button_select.disabled=true
	button_select.pressed.connect(_onButtonSelected)
	edit_search.text_changed.connect(_onSearchTextChanged)
	option.item_selected.connect(_onOptionSelectionChanged)
	button_download.pressed.connect(_onDownloadPressed)
	
func _onSearchTextChanged():
	_filterShaders()

func _onOptionSelectionChanged(index:int):
	_filterShaders()

func _getSelectedGroup()->String:
	var id=option.get_selected_id()
	return option.get_item_text(id)

func _filterShaders():
	var textToSearch:String=edit_search.text
	var groupToSearch:String=_getSelectedGroup()
	textToSearch=textToSearch.to_upper()
	shaders.clear()
	if(textToSearch.length()>0):
		for shader in allShaders:
			if(shader.name.to_upper().contains(textToSearch)):
				if(option.get_selected_id()>0):
					if(shader.group==groupToSearch):
						shaders.append(shader)
				else:
					shaders.append(shader)
	elif(option.get_selected_id()>0):
		for shader in allShaders:
			if(shader.group==groupToSearch):
				shaders.append(shader)
	else:
		shaders.append_array(allShaders)

	_refreshTree()
	
		
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
	_onShaderSelected()
	
func _onShaderSelected():
	var treeItem:TreeItem=tree.get_selected()
	var text=treeItem.get_text(0)
	var shader:ShaderInfo=_findShaderByName(text)
	if(shader!=null):
		_fillShaderInfo(shader)
		panel_right.visible=true
		button_select.disabled=false
		var downloaded:bool=ShaderInfo.shaderHasBeenDownloaded(shader)
		if(!downloaded):
			%button_download.visible = true
			%supergodot.visible=false
		else:
			var shaders:Array[ShaderInfo]=[]
			shaders.append(shader)
			var shaderCode:Shader=shader.generateShaderCode(shaders)
			%supergodot.material.shader=shaderCode
			%button_download.visible = false
			%supergodot.visible=true
	else:
		panel_right.visible=false
		button_select.disabled=true

func _onDownloadPressed():
	var treeItem:TreeItem=tree.get_selected()
	var text=treeItem.get_text(0)
	var shader:ShaderInfo=_findShaderByName(text)
	self.logic.onDownloadShaderPressed(shader.name,self,true)

	%supergodot.visible=true
	%button_download.visible=false
	var shaders=[]
	shaders.append(shader)
	var shaderCode:Shader=shader.generateShaderCode(shaders)
	%supergodot.material.shader=shaderCode


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

func setShaders(shaders:Array[ShaderInfo], logic:ExtensionLogic):
	self.allShaders=shaders
	self.logic=logic
	self.shaders.append_array(allShaders);
	var groups=self.getGroups(allShaders)
	self.option.add_item("All Groups")
	for group in groups:
		self.option.add_item(group.to_lower().capitalize())
	_refreshTree()

func _refreshTree():
	tree.clear()
	
	var allItem:TreeItem=tree.create_item();
	allItem.set_text(0,"All Shaders")
	var groups:Array[String]=self.getGroups(shaders)
	for group in groups:
		var item:TreeItem=tree.create_item(allItem);
		item.set_text(0,group.to_lower().capitalize())
		var shadersOfGroup=getShaderOfGroup(shaders, group)
		for shader in shadersOfGroup:
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
