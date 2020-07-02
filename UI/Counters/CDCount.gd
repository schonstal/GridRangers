extends Node2D

onready var label = $Badge/Sprite/Label
onready var animation = $Badge/AnimationPlayer
onready var tween = $Tween
onready var icon = $Icon

func _ready():
  EventBus.connect("coin_collected", self, "_on_coin_collected")
  EventBus.connect("coins_spent", self, "_on_coins_spent")
  animation.play("Appear")

func _on_coin_collected():
  animation.play("Increase")

func _on_coins_spent(count):
  if count == 0:
    tween.interpolate_property(
        self,
        "modulate",
        Color(10, 10, 10, 1),
        Color(1, 1, 1, 1),
        0.3,
        Tween.TRANS_QUART,
        Tween.EASE_OUT
    )
    tween.start()
  else:
    animation.stop()
    animation.play("Increase")


func _process(delta):
  label.text = "%d" % Game.scene.coins
