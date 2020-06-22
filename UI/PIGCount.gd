extends Node2D

onready var label = $Badge/Sprite/Label
onready var badge = $Badge
onready var animation = $Badge/AnimationPlayer
onready var sprite = $Head

func _ready():
  EventBus.connect("enemy_died", self, "_on_enemy_died")
  EventBus.connect("start_level", self, "_on_start_level")
  EventBus.connect("level_completed", self, "_on_level_completed")

func _on_start_level():
  animation.play("Appear")

func _on_level_completed():
  animation.play_backwards("Appear")

func _on_enemy_died(_e):
  if Game.scene.kills <= Game.scene.kill_target:
    animation.play("Increase")

func _process(delta):
  if Game.scene.kills < Game.scene.kill_target:
    label.text = "%0d/%d" % [Game.scene.kills, Game.scene.kill_target]
  else:
    label.text = "%0d/%d" % [Game.scene.kill_target, Game.scene.kill_target]
