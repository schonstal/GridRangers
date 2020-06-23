extends BackBufferCopy

export var strength = 0.1

onready var filter = $ChromaticAb

func _ready():
  filter.strength = strength
