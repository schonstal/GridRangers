extends Node2D

func _ready():
  EventBus.connect("play_sound", self, "_on_play_sound")

func _on_play_sound(category, sfx_name):
  if Game.scene.phase == Game.PHASE_NONE:
    return

  for child in get_children():
    if child.name == category:
      continue
    var node = child.find_node(sfx_name)
    if node != null && node.has_method("stop"):
      node.volume_db = -80

  var child = find_node(category)
  if category != null:
    var node = child.find_node(sfx_name)
    if node != null && node.has_method("play"):
      node.volume_db = 0
      node.play()
