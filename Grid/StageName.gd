extends Label

func _ready():
  EventBus.connect("start_level", self, "_on_start_level")
  if Game.tutorial:
    text = "The Basics"
  else:
    text = Game.scene.current_level.title

func _on_start_level():
  text = Game.scene.current_level.title
