extends Label

func _ready():
  EventBus.connect("start_level", self, "_on_start_level")

func _on_start_level():
  text = "STAGE %d" % [Game.scene.level_index + 1] 
