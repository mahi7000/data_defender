extends Node

static func create_panel_style() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color("0A0A2A")
	style.border_color = Color("00FFFF")
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_right = 8
	style.corner_radius_bottom_left = 8
	style.shadow_color = Color("00FFFF")
	style.shadow_size = 4
	return style

static func create_label_style() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.TRANSPARENT
	return style

static func create_button_style() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color("0A0A2A")
	style.border_color = Color("FF00FF")
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_right = 6
	style.corner_radius_bottom_left = 6
	
	# Hover state
	var hover_style = style.duplicate()
	hover_style.bg_color = Color("1A1A3A")
	
	return style

static func apply_cyber_font(label: Label, size: int = 24):
	var font = Label.new().get_theme_font("font")
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color("00FFFF"))
	label.add_theme_color_override("font_shadow_color", Color("FF00FF"))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
