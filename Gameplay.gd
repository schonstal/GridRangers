extends Node2D

onready var grid = $Grid
onready var ai_director = $AIDirector
onready var pathfinder = $Pathfinder

var max_player_moves = 3
var max_energy = 15

var combo = 0
var player_moves = 1
var player_control = true setget ,get_player_control

var kills = 0
var kill_target = 8
var coins = 0
var energy = 0
var cola = 0

var enemy_count = 6

var phase = Game.PHASE_NONE

var enemy_tile_scenes = [
  preload("res://Tiles/Cops/Standard/StandardCop.tscn"),
  preload("res://Tiles/Cops/Moto/MotoCop.tscn"),
  preload("res://Tiles/Cops/Shield/ShieldCop.tscn")
]

var players = {}

var players_alive = {
  'blue': true,
  'red': true,
  'yellow': true
 }

func _ready():
  EventBus.connect("turn_complete", self, "_on_turn_complete")
  EventBus.connect("phase_transition_complete", self, "_on_phase_transition_complete")
  EventBus.connect("change_phase", self, "_on_change_phase")
  EventBus.connect("begin_phase", self, "_on_begin_phase")
  EventBus.connect("enemy_died", self, "_on_enemy_died")
  EventBus.connect("coin_collected", self, "_on_coin_collected")
  EventBus.connect("cola_collected", self, "_on_cola_collected")
  EventBus.connect("energy_collected", self, "_on_energy_collected")
  EventBus.connect("energy_spent", self, "_on_energy_spent")
  EventBus.connect("player_acted", self, "_on_player_acted")
  EventBus.connect("coins_spent", self, "_on_coins_spent")
  EventBus.connect("start_level", self, "_on_start_level")
  EventBus.connect("quit_game", self, "_on_quit_game")
  EventBus.connect("player_died", self, "_on_player_died")
  EventBus.connect("revive_ranger", self, "_on_revive_ranger")

  MusicPlayer.fade("ambient", 0.3)

func _enter_tree():
  Game.initialize()

func get_enemy_scene():
  enemy_tile_scenes.shuffle()
  return enemy_tile_scenes[0]

func disable_input():
  player_control = false

func enable_input():
  player_control = true

func get_player_control():
  return player_control && player_moves > 0

func _on_revive_ranger(player_color):
  players_alive[player_color] = true

func _on_player_died(player_color):
  players_alive[player_color] = false

  var game_over = true
  for key in players_alive:
    if players_alive[key]:
      game_over = false

  if game_over:
    EventBus.emit_signal("game_over")

func _on_player_acted():
  if phase == Game.PHASE_PLAYER:
    player_moves -= 1
    if player_moves < 0:
      player_moves = 0
    EventBus.emit_signal("turns_spent", 1)

func _on_turn_complete():
  if phase != Game.PHASE_NONE && kills >= kill_target:
    disable_input()
    phase = Game.PHASE_NONE
    EventBus.emit_signal("change_phase", Game.PHASE_NONE)
    EventBus.emit_signal("level_completed")
    return

  if phase == Game.PHASE_PLAYER:
    cola = 0
    combo = 0
    enable_input()
    if player_moves < 1:
      EventBus.emit_signal("change_phase", Game.PHASE_ENEMY)

func _on_change_phase(new_phase):
  if player_moves < 1:
    player_moves = 1
  disable_input()
  phase = new_phase

func _on_phase_transition_complete():
  EventBus.emit_signal("begin_phase", phase)

func _on_begin_phase(new_phase):
  if new_phase == Game.PHASE_PLAYER:
    enable_input()
    player_moves = 1
    cola = 0

func _on_cola_collected():
  if phase == Game.PHASE_NONE:
    return
  cola += 67
  if cola >= 100:
    cola -= 100
    if player_moves < max_player_moves:
      player_moves += 1
    EventBus.emit_signal("turns_spent", -1)

func _on_coin_collected():
  if phase == Game.PHASE_NONE:
    return
  coins += 1

func _on_enemy_died(enemy):
  if phase == Game.PHASE_NONE:
    return
  kills += 1

func _on_energy_collected():
  if phase == Game.PHASE_NONE:
    return
  if energy < max_energy:
    energy += 1
  else:
    energy = max_energy

func _on_energy_spent(amount):
  if energy > amount:
    energy -= amount
  else:
    energy = 0

func _on_coins_spent(amount):
  if coins > amount:
    coins -= amount
  else:
    coins = 0

func _on_start_level():
  kills = 0
