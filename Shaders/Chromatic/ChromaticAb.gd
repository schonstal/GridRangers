extends ColorRect

onready var blur_tween = $BlurTween
var strength = 0.1

func _ready():
  mouse_filter = MOUSE_FILTER_IGNORE
  EventBus.connect("blur_chromatic", self, "_on_blur_chromatic")
  EventBus.connect("victory", self, "_on_victory")

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

func _on_victory():
  blur_tween.interpolate_property(
    self,
    "strength",
    strength,
    1.0,
    2.0,
    Tween.TRANS_QUART,
    Tween.EASE_OUT,
    3.0
  )
  blur_tween.start()
