extends Node2D

var shop_ability = preload("res://Abilities/Shop/ShopAbility.tscn")
var revive = preload("res://Abilities/Revive.tscn")

export(Array,Resource) var ability_pool = []

var abilities = [null, null, null]

func spawn_abilities():
  for i in abilities.size():
    abilities[i] = null

  for child in get_children():
    child.queue_free()

  var start = 0

  for color in Game.scene.players_alive:
    if !Game.scene.players_alive[color]:
      start = 1
      add_ability(revive, randi() % abilities.size())
      break

  ability_pool.shuffle()
  for i in abilities.size():
    if abilities[i] == null:
      add_ability(ability_pool[i], i)

  print_messages()

func print_messages():
  for a in abilities:
    var format = "# %s"
    for message in a.ability.description:
      EventBus.emit_signal("keeper_message", format % message)
      format = "  %s"

func add_ability(ability, index):
  var instance = shop_ability.instance()
  instance.ability = ability.instance()
  instance.add_child(instance.ability)
  instance.position.x = index * 300
  abilities[index] = instance
  call_deferred("add_child", instance)
