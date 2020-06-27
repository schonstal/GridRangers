extends ColorRect

var time = 0

func _ready():
  mouse_filter = MOUSE_FILTER_IGNORE

func _process(delta):
  time += delta
  material.set_shader_param("time", time)
