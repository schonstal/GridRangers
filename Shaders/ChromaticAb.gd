extends ColorRect

onready var blur_tween = $BlurTween
var strength = 0.1

func _ready():
  mouse_filter = MOUSE_FILTER_IGNORE
  EventBus.connect("blur_chromatic", self, "_on_blur_chromatic")

func _process(delta):
  material.set_shader_param("amount", strength)

func _on_blur_chromatic(size, duration):
  blur_tween.interpolate_property(
    self,
    "strength",
    size,
    0.1,
    duration,
    Tween.TRANS_QUART,
    Tween.EASE_OUT
  )
  blur_tween.start()
