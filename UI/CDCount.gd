extends Sprite

onready var label = $Label

func _process(delta):
  label.text = "%d" % Game.scene.coins
