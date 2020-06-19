extends Node2D

onready var label = $Badge/Label
onready var badge = $Badge
onready var animation = $AnimationPlayer
onready var sprite = $Head

func _ready():
  EventBus.connect("enemy_died", self, "_on_enemy_died")
  
func _on_enemy_died(_e):
  if Game.scene.kills >= Game.scene.kill_target:
    badge.visible = false
    sprite.modulate = Color(10, 10, 10, 1)
  else:
    animation.play("Increase")

func _process(delta):
  if Game.scene.kills < Game.scene.kill_target:
    label.text = "%0d/%d" % [Game.scene.kills, Game.scene.kill_target]
  else:
    label.text = "%0d/%d" % [Game.scene.kill_target, Game.scene.kill_target]
