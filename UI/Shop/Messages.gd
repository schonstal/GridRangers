extends Node2D

var messages = []

var message_scene = preload("res://UI/Shop/K33p3rMsg.tscn")

func _ready():
  EventBus.connect("keeper_message", self, "_on_keeper_message")

func _on_keeper_message(message):
  var instance = message_scene.instance()
  if messages.size() >= 9:
    var front = messages.pop_front()
    front.queue_free()
    for m in messages:
      m.position.y = m.position.y - 36

  messages.push_back(instance)
  instance.text = message
  instance.position.y = (messages.size() - 1) * 36
  add_child(instance)
