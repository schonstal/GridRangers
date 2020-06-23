extends Sprite

onready var glitch_timer = $GlitchTimer
onready var clean_timer = $CleanTimer

func _ready():
  frame = 1
  glitch_timer.connect("timeout", self, "_on_GlitchTimer_timeout")
  
func _on_GlitchTimer_timeout():
  call_deferred("glitch")
  
func glitch():
  frame = 0
  clean_timer.start(rand_range(0.05, 0.1))
  yield(clean_timer, "timeout")
  frame = 1
  glitch_timer.start(rand_range(0.01, 1.0))
