extends Node2D

onready var label = $Badge/Sprite/Label
onready var animation = $Badge/AnimationPlayer

func _ready():
  EventBus.connect("coin_collected", self, "_on_coin_collected")
  EventBus.connect("coins_spent", self, "_on_coins_spent")
  animation.play("Appear")

func _on_coin_collected():
  animation.play("Increase")

func _on_coins_spent(_count):
  animation.play("Increase")

func _process(delta):
  label.text = "%d" % Game.scene.coins
