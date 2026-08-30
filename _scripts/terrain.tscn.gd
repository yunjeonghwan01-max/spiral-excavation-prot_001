@tool
extends TileMapLayer

const GRID_WIDTH := 20
const GRID_HEIGHT := 15
const SOURCE_ID := 0


func _ready() -> void:
	if get_used_cells().is_empty():
		_generate_default_terrain()


func _generate_default_terrain() -> void:
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			set_cell(Vector2i(x, y), SOURCE_ID, Vector2i.ZERO)


func has_block(grid_pos: Vector2i) -> bool:
	return get_cell_source_id(grid_pos) != -1


func remove_block(grid_pos: Vector2i) -> void:
	erase_cell(grid_pos)


func get_dig_time(grid_pos: Vector2i) -> float:
	var tile_data := get_cell_tile_data(grid_pos)
	if tile_data == null:
		return 0.0
	return tile_data.get_custom_data("dig_time")


func world_to_grid(world_pos: Vector2) -> Vector2i:
	return local_to_map(to_local(world_pos))
