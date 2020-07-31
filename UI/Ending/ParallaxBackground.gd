extends ParallaxBackground

func _process(delta):
  scroll_offset += Vector2(50 * delta, 0)
