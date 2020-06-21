extends Node

var scene:Node

var tile_selected = Vector2(-1, -1)

var PHASE_PLAYER = "player"
var PHASE_ENEMY = "enemy"

# Non-gameplay (shop, startup, etc)
var PHASE_NONE = "none"

func _ready():
  randomize()
  scene = $'../Gameplay'
