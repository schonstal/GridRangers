extends Sprite

onready var label = $Label

func _process(delta):
  label.text = "%0d/%d" % [Game.scene.kills, Game.scene.kill_target]
