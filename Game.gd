extends Node

var scene:Node

var tile_selected = Vector2(-1, -1)

var PHASE_PLAYER = "player"
var PHASE_ENEMY = "enemy"

# Non-gameplay (shop, startup, etc)
var PHASE_NONE = "none"

var target_scene

var ENEMY_SCENES = {
  'standard': preload("res://Tiles/Cops/Standard/StandardCop.tscn"),
  'moto': preload("res://Tiles/Cops/Moto/MotoCop.tscn"),
  'shield': preload("res://Tiles/Cops/Shield/ShieldCop.tscn")
}

func _ready():
  randomize()
  Overlay.connect("fade_complete", self, "_on_Overlay_fade_complete")
  EventBus.connect("restart_game", self, "_on_restart_game")

func _on_restart_game():
  Game.reset()

func initialize():
  scene = $'../Gameplay'

func reset():
  Game.change_scene("res://Gameplay.tscn")

func change_scene(scene):
  target_scene = scene
  Overlay.fade(Color(0, 0, 0, 0), Color(0, 0, 0, 1), 0.3)

func _on_Overlay_fade_complete():
  if target_scene != null:
    get_tree().change_scene(target_scene)
    target_scene = null
    Overlay.fade(Color(0, 0, 0, 1), Color(0, 0, 0, 0), 0.3)
