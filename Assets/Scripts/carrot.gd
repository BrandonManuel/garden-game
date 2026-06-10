extends Area2D

var tile_position
func _ready():
	var tilemap = get_parent()
	tile_position = tilemap.local_to_map(position)
	
func picked_up():
	var tilemap = get_parent()
	tilemap.set_cell(tile_position)
	queue_free()
