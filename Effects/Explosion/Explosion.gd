extends Sprite

onready var animation = $AnimationPlayer

func _ready():
  animation.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished(name):
  queue_free()
