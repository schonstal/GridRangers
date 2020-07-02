extends Node2D

var low_pass:AudioEffectLowPassFilter
var pitch_shift:AudioEffectPitchShift
var bus_index = 0
var pitch_shift_index = 0
var music_volume = 0
var current_stream = "title"

onready var streams = {
  "ambient": $Streams/Ambient,
  "big_band": $Streams/BigBand,
  "title": $Streams/Title,
  "end": $Streams/End
}

onready var volumes = {
  "ambient": 0,
  "big_band": -6,
  "title": 0,
  "end": 0
}

onready var fade_tween = $FadeTween
onready var filter_tween = $FilterTween

func _ready():
  EventBus.connect("game_over", self, "_on_game_over")

  bus_index = AudioServer.get_bus_index("Music")

  pitch_shift = AudioEffectPitchShift.new()
  pitch_shift.pitch_scale = 1

  AudioServer.add_bus_effect(bus_index, pitch_shift, pitch_shift_index)

  disable_filter()

func _process(_delta):
  AudioServer.set_bus_volume_db(bus_index, music_volume)

func _on_game_over():
  for key in streams:
    streams[key].volume_db = -80
    streams[key].stop()
  current_stream = null

func disable_filter():
  filter_tween.stop(pitch_shift)
  AudioServer.set_bus_effect_enabled(bus_index, pitch_shift_index, false)

func enable_filter():
  filter_tween.stop(pitch_shift)
  AudioServer.set_bus_effect_enabled(bus_index, pitch_shift_index, true)

func fade_filter(duration):
  enable_filter()

  filter_tween.interpolate_property(
      pitch_shift,
      "pitch_scale",
      0.5,
      1.0,
      duration,
      Tween.TRANS_QUAD,
      Tween.EASE_OUT)

  filter_tween.start()
  yield(filter_tween, "tween_completed")
  disable_filter()

func fade(mode, duration):
  if mode != null:
    streams[mode].play()
    streams[mode].volume_db = -80

    fade_tween.interpolate_property(
        streams[mode],
        "volume_db",
        -80,
        volumes[mode],
        duration,
        Tween.TRANS_QUAD,
        Tween.EASE_IN)

  if current_stream != null:
    fade_tween.interpolate_property(
        streams[current_stream],
        "volume_db",
        volumes[current_stream],
        -80,
        duration,
        Tween.TRANS_QUAD,
        Tween.EASE_IN)

  fade_tween.start()
  yield(fade_tween, "tween_completed")

  if current_stream != null:
    streams[current_stream].stop()

  current_stream = mode
