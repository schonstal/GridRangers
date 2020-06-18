extends Node2D

onready var grid = $Grid
onready var ai_director = $AIDirector
onready var pathfinder = $Pathfinder

var max_player_moves = 3

var combo = 0
var player_moves = max_player_moves
var player_control = true

var phase = Game.PHASE_PLAYER

var players = []

func _ready():
  EventBus.connect("turn_complete", self, "_on_turn_complete")
  EventBus.connect("phase_transition_complete", self, "_on_phase_transition_complete")
  EventBus.connect("change_phase", self, "_on_change_phase")
  EventBus.connect("begin_phase", self, "_on_begin_phase")
  EventBus.connect("player_died", self, "_on_player_died")

func disable_input():
  player_control = false

func enable_input():
  player_control = true

func _on_turn_complete():
  if phase == Game.PHASE_PLAYER:
    combo = 0
    enable_input()
    player_moves -= 1
    if player_moves < 1:
      EventBus.emit_signal("change_phase", Game.PHASE_ENEMY)

func _on_change_phase(new_phase):
  disable_input()
  phase = new_phase

func _on_phase_transition_complete():
  EventBus.emit_signal("begin_phase", phase)

func _on_begin_phase(new_phase):
  if new_phase == Game.PHASE_PLAYER:
    enable_input()
    player_moves = max_player_moves

func _on_player_died(player):
  var index = players.find(player)
  if index > -1:
    players.remove(index)
