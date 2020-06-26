extends Label

func _process(_delta):
  text = "Your winnings: %d CDs" % Game.scene.coins
