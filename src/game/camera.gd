extends CanvasLayer

@export var dark_hud: TextureRect
@export var white_hud: TextureRect

func set_night_mode():
	dark_hud.hide()
	white_hud.show()

func set_day_mode():
	dark_hud.show()
	white_hud.hide()
