extends Node2D

var points_to_draw: PackedVector2Array = []

func _draw():
	if points_to_draw.size() > 1:
		# Draw a line at least as wide as the sprite that we want to draw. Color doesn't matter
		draw_polyline(points_to_draw, Color.WHITE, 100.0, true)
