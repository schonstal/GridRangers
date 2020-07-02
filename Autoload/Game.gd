extends Node

var scene:Node

var tile_selected = Vector2(-1, -1)

var PHASE_PLAYER = "player"
var PHASE_ENEMY = "enemy"

# Non-gameplay (shop, startup, etc)
var PHASE_NONE = "none"

var target_scene
var tutorial = true

var TUTORIAL_SCENES = [
  preload("res://Tiles/Cola/Cola.tscn"),
  preload("res://Tiles/Energy/EnergyTile.tscn"),
  preload("res://Tiles/OtherEnergy/EnergyTile.tscn"),
  preload("res://Tiles/Coin/CoinTile.tscn"),
  preload("res://Tiles/Wall/WallTile.tscn"),
  preload("res://Tiles/Cops/standard/StandardCop.tscn"),
  preload("res://Tiles/Rangers/RedRanger.tscn"),
  preload("res://Tiles/Rangers/BlueRanger.tscn"),
  preload("res://Tiles/Rangers/YellowRanger.tscn")
]

var TUTORIAL_LEVEL = [
  [0, 0, 1, 2, 5, 1, 2],
  [1, 5, 2, 5, 3, 0, 4],
  [1, 3, 3, 0, 1, 4, 0],
  [2, 5, 1, 0, 3, 1, 0],
  [4, 0, 4, 5, 2, 5, 1],
  [3, 0, 1, 4, 3, 2, 2],
  [3, 6, 1, 7, 3, 8, 2],
  [0, 2, 3, 0, 4, 0, 4]
]

var ENEMY_SCENES = {
  'standard': preload("res://Tiles/Cops/standard/StandardCop.tscn"),
  'moto': preload("res://Tiles/Cops/moto/MotoCop.tscn"),
  'shield': preload("res://Tiles/Cops/shield/ShieldCop.tscn")
}

func _ready():
  randomize()
  Overlay.connect("fade_complete", self, "_on_Overlay_fade_complete")
  EventBus.connect("restart_game", self, "_on_restart_game")
  EventBus.connect("quit_game", self, "_on_quit_game")

func _on_quit_game():
  get_tree().quit()

func _on_restart_game():
  Game.reset()

func initialize():
  scene = $'../Gameplay'

func reset():
  Game.change_scene("res://Scenes/Gameplay/Gameplay.tscn")

func return_to_title():
  MusicPlayer.fade("title", 0.5)
  Game.change_scene("res://Scenes/TitleScreen/TitleScreen.tscn")

func change_scene(scene):
  target_scene = scene
  Overlay.fade(Color(0, 0, 0, 0), Color(0, 0, 0, 1), 0.3)

func _on_Overlay_fade_complete():
  if target_scene != null:
    get_tree().change_scene(target_scene)
    target_scene = null
    Overlay.fade(Color(0, 0, 0, 1), Color(0, 0, 0, 0), 0.3)
