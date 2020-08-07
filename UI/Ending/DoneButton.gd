extends Area2D

var clicked = false
var active = false

onready var animation = $AnimationPlayer
onready var appear_timer = $AppearTimer
onready var appear_tween = $AppearTween
onready var sprite = $Sprite

var click_sound:AudioStreamPlayer

var opaque:bool = false setget set_opaque,get_opaque
  
func _ready():
  visible = false
  
  EventBus.connect("victory", self, "_on_victory")
  
  appear_timer.connect("timeout", self, "_on_AppearTimer_timeout")
    
  connect("mouse_exited", self, "_on_mouse_exited")
  connect("mouse_entered", self, "_on_mouse_entered")
  connect("input_event", self, "_on_input_event")
  animation.play("Idle")

  click_sound = AudioStreamPlayer.new()
  click_sound.stream = preload("res://sfx/Click_SFX.ogg")
  add_child(click_sound)
  
func _process(delta):
  if active && (Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("ui_touch")):
    show()
  
func show():
  if visible:
    return

  animation.play("Appear")

func _on_mouse_entered():
  self.opaque = true

func _on_mouse_exited():
  clicked = false
  self.opaque = false
  
func _on_victory():
  active = true
  appear_timer.start()

func _on_input_event(_viewport, event, _shape_id):
  if !active || !visible:
    return

  if event is InputEventMouseButton:
    if event.button_index == BUTTON_LEFT:
      if event.pressed:
        clicked = true
        click_sound.play()
        self.opaque = true
      if !event.pressed && clicked:
        clicked = false
        Game.return_to_title()

func _on_AppearTimer_timeout():
  show()
  
func set_opaque(value):
  if value:
    sprite.frame = 1
  else:
    sprite.frame = 0
    
func get_opaque():
  return opaque
