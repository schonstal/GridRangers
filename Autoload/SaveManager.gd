extends Node

var save = {}

var dirty = false

var file_path = "user://grid_rangers.save"

func _ready():
  load_save()

func _process(_delta):
  if dirty:
    write_save()

func write_save():
  var save_file = File.new()
  save_file.open(file_path, File.WRITE)
  save_file.store_line(to_json(save))
  save_file.close()

func load_save():
  var save_file = File.new()
  if !save_file.file_exists(file_path):
    return

  save_file.open(file_path, File.READ)
  save = parse_json(save_file.get_line())

  save_file.close()

func get_value(key):
  if save.has(key):
    return save[key]
  else:
    return null

func set_value(key, value):
  save[key] = value
  dirty = true
