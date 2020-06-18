extends Sprite

onready var label = $Label

func _process(delta):
  label.text = "%d MB" % Game.scene.coins
