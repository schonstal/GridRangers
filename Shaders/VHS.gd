extends ColorRect

func _ready():
  mouse_filter = MOUSE_FILTER_IGNORE

var time = 0
func _process(delta):
  material.set_shader_param("time", time)
  time += delta
