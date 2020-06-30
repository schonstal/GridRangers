extends Node2D

var text = "Thx :)"

onready var message = $Message

func _ready():
  message.text = text
