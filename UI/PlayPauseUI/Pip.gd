extends Node2D

onready var pipe = $Pipe
onready var dash = $Dash

func enable():
  pipe.visible = true
  dash.visible = false

func disable():
  pipe.visible = false
  dash.visible = true
