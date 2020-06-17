extends Node

var timer:Timer
var wait_time = 0.5

func perform():
  timer = Timer.new()
  timer.one_shot = true
  Game.scene.add_child(timer)
  timer.start(wait_time)

  Game.scene.grid.execute_match()

  yield(timer, "timeout")
