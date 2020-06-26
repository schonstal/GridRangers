extends Node2D

var explosion_scene = preload("res://Effects/Explosion/Explosion.tscn")

func _ready():
  EventBus.connect("explode", self, "_on_explode")
  EventBus.connect("game_over", self, "_on_game_over")
  
func _on_game_over():
  visible = false

func _on_explode(position):
  var instance = explosion_scene.instance()
  instance.global_position = position
  call_deferred("add_child", instance)
