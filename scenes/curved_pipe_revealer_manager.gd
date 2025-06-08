extends Node2D

# References to our other nodes
@onready var sprite_to_reveal: Sprite2D = $SpriteToRevealSprite2D
@onready var mask_viewport: SubViewport = $MaskViewport
@onready var mask_drawer: Node2D = $MaskViewport/MaskDrawer

# Assign these in the inspector. These values are relative to the MaskViewport (SubViewport)
@export var p0: Vector2 = Vector2(50.0, 150.0)
@export var p1: Vector2 = Vector2(50.0, 50.0)
@export var p2: Vector2 = Vector2(150.0, 50.0)

# 't' is the progress along the curve, from 0.0 to 1.0
var t: float = 0.0
var traced_points: PackedVector2Array = []

func _ready():
	p0 += mask_drawer.position
	p1 += mask_drawer.position
	p2 += mask_drawer.position
	
	# We tell the sprite's shader to use the MaskViewport's texture as the "mask_texture" variable in the shader script.
	sprite_to_reveal.material.set_shader_parameter("mask_texture", mask_viewport.get_texture())

func _unhandled_input(event: InputEvent):
	# Restart animation
	if event.is_action_pressed("ui_accept"):
		t = 0.0
		traced_points.clear()
		mask_drawer.points_to_draw = []
		mask_drawer.queue_redraw()

func _process(delta: float):
	if t < 1.0:
		t = min(t + delta * 0.2, 1.0)

	# Calculate the current point on the curve
	var q0: Vector2 = p0.lerp(p1, t)
	var q1: Vector2 = p1.lerp(p2, t)
	var r: Vector2 = q0.lerp(q1, t)

	# Add the point to our path if it has moved then redraw all points
	if traced_points.is_empty() or !traced_points.has(r):
		traced_points.append(r)
		mask_drawer.points_to_draw = traced_points
		mask_drawer.queue_redraw()
