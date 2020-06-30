extends Sprite

func _ready():
  set_material(material.duplicate())

var time = 0
func _process(delta):
  material.set_shader_param("time", time)
  time += delta
