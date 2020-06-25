extends Label

func _ready():
  EventBus.connect("start_level", self, "_on_start_level")

func _on_start_level():
  text = "STAGE %d\n%s" % [Game.scene.level_index + 1, Game.scene.current_level.title]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
