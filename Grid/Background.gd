extends Sprite

var fade = 0

func _process(delta):
  material.set_shader_param("alpha", fade)
