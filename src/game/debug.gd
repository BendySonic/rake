extends CanvasLayer

@export var fps_label: Label

func _physics_process(delta: float) -> void:
	fps_label.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
