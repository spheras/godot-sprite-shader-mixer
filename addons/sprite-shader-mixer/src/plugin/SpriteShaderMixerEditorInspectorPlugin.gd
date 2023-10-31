extends EditorInspectorPlugin

var ex_view = preload("res://addons/sprite-shader-mixer/src/extension/ExtensionView.tscn")

func _can_handle(object):
	return (object is Sprite2D) or 	(object is AnimatedSprite2D) or	(object is Label) or (object is ColorRect)

func _parse_begin(object):
	var view = ex_view.instantiate()
	view.setParentSprite(object)
	add_custom_control(view)
