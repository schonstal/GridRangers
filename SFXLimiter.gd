extends Node2D

func _ready():
  EventBus.connect("play_sound", self, "_on_play_sound")

func _on_play_sound(category, sfx_name):
  if Game.scene.phase == Game.PHASE_NONE:
    return

  var child = find_node(category)
  if category != null:
    var node = child.find_node(sfx_name)
    if node != null && node.has_method("play"):
      node.play()
