extends ColorRect

@export var grid_color: Color = Color("1A1A3A")
@export var grid_highlight_color: Color = Color("2A2A4A")
@export var grid_size: int = 50

func _ready():
	# Fill the entire viewport
	size = get_viewport_rect().size
	color = Color("0A0A2A")  # Dark blue background
	
	# Force redraw
	queue_redraw()

func _draw():
	var viewport_size = get_viewport_rect().size
	
	# Draw grid
	for x in range(0, int(viewport_size.x), grid_size):
		var line_color = grid_highlight_color if x % (grid_size * 5) == 0 else grid_color
		draw_line(Vector2(x, 0), Vector2(x, viewport_size.y), line_color, 1.0)
	
	for y in range(0, int(viewport_size.y), grid_size):
		var line_color = grid_highlight_color if y % (grid_size * 5) == 0 else grid_color
		draw_line(Vector2(0, y), Vector2(viewport_size.x, y), line_color, 1.0)
	
	# Draw cyber nodes
	draw_cyber_nodes()

func draw_cyber_nodes():
	var viewport_size = get_viewport_rect().size
	var rng = RandomNumberGenerator.new()
	
	for i in range(15):
		var pos = Vector2(
			rng.randf_range(30, viewport_size.x - 30),
			rng.randf_range(30, viewport_size.y - 30)
		)
		
		# Vary node colors
		var node_color = Color("00FFFF")
		if i % 3 == 0:
			node_color = Color("FF00FF")
		elif i % 3 == 1:
			node_color = Color("00FF00")
		
		# Draw pulsing circles
		var size = rng.randf_range(2.0, 4.0)
		draw_circle(pos, size, node_color)
		
		# Draw connecting lines between some nodes
		if i > 0:
			var prev_pos = Vector2(
				rng.randf_range(30, viewport_size.x - 30),
				rng.randf_range(30, viewport_size.y - 30)
			)
			draw_line(prev_pos, pos, node_color * Color(1, 1, 1, 0.3), 1.0)
