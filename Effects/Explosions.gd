extends Node2D

var explosion_scene = preload("res://Effects/Explosion/Explosion.tscn")

func _ready():
  EventBus.connect("explode", self, "_on_explode")

func _on_explode(position):
  var instance = explosion_scene.instance()
  instance.global_position = position
  call_deferred("add_child", instance)
