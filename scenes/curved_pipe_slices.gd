extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# This function runs when an input event (like a key press) occurs.
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		animation_player.stop()
		animation_player.play("fill_pipe_2")
