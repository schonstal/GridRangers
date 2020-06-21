extends AudioStreamPlayer

var low_pass:AudioEffectLowPassFilter
var pitch_shift:AudioEffectPitchShift
var bus_index = 0
var pitch_shift_index = 0
var music_volume = 0
var current_file = ""

onready var fade_tween = $FadeTween
onready var filter_tween = $FilterTween

func _ready():
  bus_index = AudioServer.get_bus_index("Music")

  pitch_shift = AudioEffectPitchShift.new()
  pitch_shift.pitch_scale = 1

  AudioServer.add_bus_effect(bus_index, pitch_shift, pitch_shift_index)
  disable_filter()

func _process(_delta):
  AudioServer.set_bus_volume_db(bus_index, music_volume)

func play_file(audio_file):
  if audio_file == current_file:
    return

  current_file = audio_file

  self.stream = load(audio_file)
  self.play()

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

func fade(start_volume_db, end_volume_db, duration):
  print("fading volume")
  fade_tween.interpolate_property(
      self,
      "music_volume",
      start_volume_db,
      end_volume_db,
      duration,
      Tween.TRANS_QUAD,
      Tween.EASE_IN)

  fade_tween.start()
