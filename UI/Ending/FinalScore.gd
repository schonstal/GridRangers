extends Label

func _ready():
  EventBus.connect("coin_collected", self, "_on_coin_collected")
  EventBus.connect("coins_spent", self, "_on_coins_spent")
  
func _on_coin_collected():
  update_text()
  
func _on_coins_spent(_amount):
  update_text()
  
func update_text():
  text = "CDS COLLECTED:\n%s" % Game.scene.coins
