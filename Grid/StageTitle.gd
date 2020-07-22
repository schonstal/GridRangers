extends VBoxContainer

func _ready():
  EventBus.connect("victory", self, "_on_victory")

func _on_victory():
  queue_free()
