extends Node2D

onready var label = $Badge/Label
onready var animation = $Badge/AnimationPlayer

func _ready():
  EventBus.connect("coin_collected", self, "_on_coin_collected")

func _on_coin_collected():
  animation.play("Increase")

func _process(delta):
  label.text = "%d" % Game.scene.coins
