extends Sprite

onready var label = $Label

func _process(delta):
  label.text = "%2d / %2d" % [Game.scene.kills, Game.scene.kill_target]
