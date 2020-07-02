extends NinePatchRect

var hidden = true

onready var animation = $AnimationPlayer
onready var label = $Label

func show():
  if hidden:
    animation.play("Appear")
    hidden = false
  
func hide():
  if !hidden:
    animation.play("Disappear")
    hidden = true
