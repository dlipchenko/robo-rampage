@tool
extends Control

func _draw() -> void:
	draw_circle(Vector2.ZERO, 2, Color.WHITE)
	draw_circle(Vector2.ZERO, 3, Color.GRAY)
	
	draw_line(Vector2(16, 0), Vector2(24, 0), Color.GRAY, 3)
	draw_line(Vector2(16, 0), Vector2(24, 0), Color.WHITE, 1)
	draw_line(Vector2(-16, 0), Vector2(-24, 0), Color.GRAY, 3)
	draw_line(Vector2(-16, 0), Vector2(-24, 0), Color.WHITE, 1)
	draw_line(Vector2(0, 16), Vector2(0, 24), Color.GRAY, 3)
	draw_line(Vector2(0, 16), Vector2(0, 24), Color.WHITE, 1)
	draw_line(Vector2(0, -16), Vector2(0, -24), Color.GRAY, 3)
	draw_line(Vector2(0, -16), Vector2(0, -24), Color.WHITE, 1)
