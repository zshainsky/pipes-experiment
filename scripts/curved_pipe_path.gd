extends Node2D

const COMPLETION_TIME = 1

@onready var p_0_marker_2d: Marker2D = $P0Marker2D
@onready var p_1_marker_2d: Marker2D = $P1Marker2D
@onready var p_2_marker_2d: Marker2D = $P2Marker2D

# p0 = Start Point
# p1 = Control Point (pulls the curve)
# p2 = End Point
@export var p0: Vector2 = Vector2.ZERO
@export var p1: Vector2 = Vector2.ZERO
@export var p2: Vector2 = Vector2.ZERO

# 't' is the progress along the curve, from 0.0 to 1.0
var t: float = 0.0

#An array to store the points of the arc as it's drawn.
var traced_points: PackedVector2Array = []

func _ready() -> void:
	p0 = p_0_marker_2d.position
	p1 = p_1_marker_2d.position
	p2 = p_2_marker_2d.position
	print(p0,p1,p2)

func _unhandled_input(event: InputEvent):
	# Reset animation
	if event.is_action_pressed("ui_accept"):
		traced_points.clear()
		t = 0.0

func _process(delta: float):
	if t < 1.0:
		# Increase 't' by a small amount each frame. Value should not be greater than 1
		t = min(t + delta * 0.2, 1.0)
		queue_redraw()

# This function handles all the drawing logic.
func _draw():
	# Draw control lines
	draw_line(p0, p1, Color.GRAY, 2)
	draw_line(p1, p2, Color.GRAY, 2)
	
	
	# Draw moving line along bezier curve
	var q0: Vector2 = p0.lerp(p1, t)
	var q1: Vector2 = p1.lerp(p2, t)
	draw_line(q0, q1, Color.WHITE, 3)
	draw_circle(q0, 8, Color.WHITE)
	draw_circle(q1, 8, Color.WHITE)
	
	# Updated point along curve and add to list of points
	var r: Vector2 = q0.lerp(q1, t)
	if traced_points.is_empty() or !traced_points.has(r):
		traced_points.append(r)
	
	# Draw all points
	if traced_points.size() > 1:
		draw_polyline(traced_points, Color.hex(0x4da5dc), 50, true)

# _quadratic_bezier computes the point at t along the bezier curve
func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r
