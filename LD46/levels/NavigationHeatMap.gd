extends Navigation2D

onready var _tile_map : TileMap = $TileMap

var heat_map : = []

func _ready() -> void:
	for x in range(PlayerData.TILE_MAP_WIDTH):
		heat_map.append([])
		for y in range(PlayerData.TILE_MAP_HEIGHT):
			heat_map[x].append(0.0)

func add_heat(position : Vector2, heat : float) -> void:
	var map_coord : = _tile_map.world_to_map(position)
	heat_map[map_coord.x][map_coord.y] += heat

func get_heat(position : Vector2) -> float:
	var map_coord : = _tile_map.world_to_map(position)
	return heat_map[map_coord.x][map_coord.y]

func get_nav_pol_with_lowest_heat(cur_pos : Vector2, rand_noise : float) -> PoolVector2Array:
	var map_coord : = _tile_map.world_to_map(cur_pos)
	var min_heat : = 1000000.0
	var min_coord : = map_coord
	var heat : = get_heat_if_navigatable(map_coord.x + 1, map_coord.y)
	if heat < min_heat + randf() * rand_noise:
		min_heat = heat
		min_coord = Vector2(map_coord.x + 1, map_coord.y)
	heat = get_heat_if_navigatable(map_coord.x - 1, map_coord.y)
	if heat < min_heat + randf() * rand_noise:
		min_heat = heat
		min_coord = Vector2(map_coord.x - 1, map_coord.y)
	heat = get_heat_if_navigatable(map_coord.x, map_coord.y + 1)
	if heat < min_heat + randf() * rand_noise:
		min_heat = heat
		min_coord = Vector2(map_coord.x, map_coord.y + 1)
	heat = get_heat_if_navigatable(map_coord.x, map_coord.y - 1)
	if heat < min_heat + randf() * rand_noise:
		min_heat = heat
		min_coord = Vector2(map_coord.x, map_coord.y - 1)
	
	var tile_index : = _tile_map.get_cellv(min_coord)
	var nav_poly : NavigationPolygon 
	if _tile_map.tile_set.tile_get_tile_mode(tile_index) == TileSet.AUTO_TILE:
		nav_poly = _tile_map.tile_set.autotile_get_navigation_polygon(tile_index, _tile_map.get_cell_autotile_coord(min_coord.x, min_coord.y))
	else:
		nav_poly = _tile_map.tile_set.tile_get_navigation_polygon(tile_index)
	var points : = nav_poly.get_vertices()
	var world_coord : = _tile_map.map_to_world(min_coord)
	for i in range(points.size()):
		points[i] += world_coord
	return points

func get_heat_if_navigatable(x : int, y : int) -> float:
	var tile_index : = _tile_map.get_cell(x, y)
	
	var nav_poly : NavigationPolygon 
	if _tile_map.tile_set.tile_get_tile_mode(tile_index) == TileSet.AUTO_TILE:
		nav_poly = _tile_map.tile_set.autotile_get_navigation_polygon(tile_index, _tile_map.get_cell_autotile_coord(x, y))
	else:
		nav_poly = _tile_map.tile_set.tile_get_navigation_polygon(tile_index)
	if nav_poly:
		return heat_map[x][y]
	return 1000000.0
