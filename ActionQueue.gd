extends Node

var queue = []
var current_action = null

func enqueue(action, args = []):
  queue.push_back([action, args])

  if queue.size() == 1:
    perform_actions()

func perform_actions():
  var current_action = queue.pop_front()

  while current_action != null:
    current_action[0].call_funcv([1])
    yield(self, "action_complete")
    current_action = queue.pop_front()
