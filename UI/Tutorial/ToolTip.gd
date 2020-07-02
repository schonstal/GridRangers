extends NinePatchRect

onready var label = $Label

func _process(delta):
  rect_size.y = label.get_combined_minimum_size().y + 80
