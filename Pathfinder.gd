extends Node2D

var astar:AStar

var path_start_position = Vector2()
var path_end_position = Vector2()

var obstacles = []
var points_array = []

var grid = null

func generate_map():
  grid = Game.scene.grid
  astar = AStar.new()
  var points = add_walkable_cells()
  connect_walkable_cells(points)

func add_walkable_cells():
  for y in grid.height:
    for x in grid.width:
      var point = Vector2(x, y)
      if !grid.get_tile(point).traversable:
        obstacles.push_back(point)
        continue

      points_array.append(point)
      var point_index = calculate_point_index(point)
      astar.add_point(point_index, Vector3(point.x, point.y, 0.0))

  return points_array

func connect_walkable_cells(points_array):
  for point in points_array:
    var point_index = calculate_point_index(point)
    var points_relative = PoolVector2Array([
      Vector2(point.x + 1, point.y),
      Vector2(point.x - 1, point.y),
      Vector2(point.x, point.y + 1),
      Vector2(point.x, point.y - 1)])

    for point_relative in points_relative:
      var point_relative_index = calculate_point_index(point_relative)

      if grid.outside_bounds(point_relative):
        continue
      if !astar.has_point(point_relative_index):
        continue
      astar.connect_points(point_index, point_relative_index, false)

func calculate_point_index(point):
  return point.x + grid.width * point.y

func find_path(start, end):
  if astar == null:
    generate_map()

  var start_point_index = calculate_point_index(start)
  var end_point_index = calculate_point_index(end)

  if !astar.has_point(start_point_index) || !astar.has_point(end_point_index):
    return []

  var point_path = astar.get_point_path(start_point_index, end_point_index)

  var path2d = []
  for vector3 in point_path:
    path2d.append(Vector2(vector3.x, vector3.y))

  return path2d
