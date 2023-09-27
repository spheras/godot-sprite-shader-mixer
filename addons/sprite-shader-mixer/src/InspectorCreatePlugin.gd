extends EditorInspectorPlugin

var ex_view = preload("./extension_view.tscn")

func _can_handle(object):
	return (object is Control) or (object is Sprite2D) or (object is AnimatedSprite2D) or (object is Node)

func _parse_begin(object):
	var view = ex_view.instantiate()
	for child in view.get_children():
		print_debug("hijo:",child.name)
	view.setParentSprite(object)
	add_custom_control(view)
