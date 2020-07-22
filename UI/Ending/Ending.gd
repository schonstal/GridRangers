extends Node2D

onready var wait_timer = $WaitTimer
onready var animation = $AnimationPlayer

func _ready():
  EventBus.connect("victory", self, "_on_victory")
  
func _on_victory():
  wait_timer.call_deferred("start")
  yield(wait_timer, "timeout")
  animation.play("Victory")
