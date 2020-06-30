extends Sprite

export var pixel_width = 393

onready var tween = $Tween
onready var label = $Label

func _ready():
  EventBus.connect("energy_collected", self, "_on_energy_collected")
  EventBus.connect("energy_spent", self, "_on_energy_spent")
  update_width()

func _on_energy_collected():
  update_width()
  label.text = "%d" % Game.scene.energy

func _on_energy_spent(_amount):
  update_width()
  label.text = "%d" % Game.scene.energy

func update_width():
  tween.stop_all()
  var width = pixel_width * Game.scene.energy / Game.scene.max_energy

  tween.interpolate_property(self, "region_rect", region_rect, Rect2(0, 0, width, 57), 0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
  tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
