extends Label

func _ready():
  EventBus.connect("start_level", self, "_on_start_level")

func _on_start_level():
  var level = Game.scene.level_index + 1

  if level >= Game.scene.levels.size():
    text = "FINAL STAGE"
  else:
    text = "STAGE %d" % level
