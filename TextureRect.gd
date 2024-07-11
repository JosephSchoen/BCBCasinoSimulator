extends TextureRect

# Triggers when you click and drag
func _get_drag_data(at_position):
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30, 30)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	
	return texture

# Triggers when you hover with dragged item
func _can_drop_data(at_position, data):
	return data is Texture2D

# Triggers when you drop dragged item
func _drop_data(at_position, data):
	texture = data

