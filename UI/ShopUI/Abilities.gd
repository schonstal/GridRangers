extends Node2D

var shop_ability = preload("res://Abilities/Shop/ShopAbility.tscn")

export(Array,Resource) var ability_pool = []

func spawn_abilities():
  for child in get_children():
    child.queue_free()
    
  ability_pool.shuffle()
  for i in 3:
    var instance = shop_ability.instance()
    instance.ability = ability_pool[i].instance()
    instance.add_child(instance.ability)
    instance.position.x = i * 300
    call_deferred("add_child", instance)
