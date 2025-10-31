extends ColorRect

@export var grid_color: Color = Color("1A1A3A")
@export var grid_highlight_color: Color = Color("2A2A4A")
@export var grid_size: int = 50

func _ready():
	# Set the background color
	color = Color("0A0A2A")
	# Make sure it covers the entire viewport
	size = get_viewport_rect().size
	# Force the first draw
	queue_redraw()

func _draw():
	var viewport_size = get_viewport().get_visible_rect().size
	
	# Draw grid lines
	for x in range(0, viewport_size.x, grid_size):
		var line_color = grid_highlight_color if x % (grid_size * 5) == 0 else grid_color
		draw_line(Vector2(x, 0), Vector2(x, viewport_size.y), line_color, 1.0)
	
	for y in range(0, viewport_size.y, grid_size):
		var line_color = grid_highlight_color if y % (grid_size * 5) == 0 else grid_color
		draw_line(Vector2(0, y), Vector2(viewport_size.x, y), line_color, 1.0)
	
	# Draw some cyber-style nodes/points
	var rng = RandomNumberGenerator.new()
	for i in range(20):
		var pos = Vector2(
			rng.randf_range(50, viewport_size.x - 50),
			rng.randf_range(50, viewport_size.y - 50)
		)
		draw_circle(pos, 2.0, Color("00FFFF").lerp(Color("FF00FF"), rng.randf()))
