# Attach this script to the "WaterDrawer" Node2D
extends Node2D

@onready var p0_marker: Marker2D = $P0Marker2D
@onready var p1_marker: Marker2D = $P1Marker2D
@onready var p2_marker: Marker2D = $P2Marker2D
@onready var line_2d: Line2D = $Line2D

var p0: Vector2
var p1: Vector2
var p2: Vector2

var t: float = 0.0
var traced_points: PackedVector2Array = []

func _ready() -> void: 
	# Start the animation for the first time
	reset_animation()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"): # Spacebar or Enter
		reset_animation()

func reset_animation():
	# Read the marker positions.
	p0 = p0_marker.position
	p1 = p1_marker.position
	p2 = p2_marker.position

	# Reset the animation variables.
	t = 0.0
	traced_points.clear()
	traced_points.append(p0)
	
	# Update the Line2D with the starting state.
	line_2d.points = traced_points

func _process(delta: float):
	if t < 1.0:
		t = min(t + delta * 0.2, 1.0)

	# Calculate the next point and add it to the list for the *next* frame.
	var r: Vector2 = _quadratic_bezier(p0, p1, p2, t)
	if traced_points.is_empty() or traced_points[-1] != r:
		traced_points.append(r)
		line_2d.points = traced_points


# Helper function to compute the point on the curve
func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float) -> Vector2:
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r
