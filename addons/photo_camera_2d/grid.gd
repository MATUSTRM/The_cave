extends Control

@export var color := Color(1, 1, 1, 0.35)
@export var thickness := 2.0

func _draw():

	var size := get_viewport_rect().size

	# Verticales
	draw_line(
		Vector2(size.x / 3.0, 0),
		Vector2(size.x / 3.0, size.y),
		color,
		thickness
	)

	draw_line(
		Vector2(size.x * 2.0 / 3.0, 0),
		Vector2(size.x * 2.0 / 3.0, size.y),
		color,
		thickness
	)

	# Horizontales
	draw_line(
		Vector2(0, size.y / 3.0),
		Vector2(size.x, size.y / 3.0),
		color,
		thickness
	)

	draw_line(
		Vector2(0, size.y * 2.0 / 3.0),
		Vector2(size.x, size.y * 2.0 / 3.0),
		color,
		thickness
	)
