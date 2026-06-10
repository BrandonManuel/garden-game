extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var tile_position
func _ready():
	var tilemap = get_parent()
	tile_position = tilemap.local_to_map(position)
	
func picked_up():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d,"position", Vector2.UP * 5, .5).as_relative().set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(sprite_2d,"region_rect", Rect2(0, 0, 16.0, 32.0), .5).set_trans(Tween.TRANS_LINEAR)

	tween.tween_callback(clear)


func clear():
	await get_tree().create_timer(.5).timeout
	var tilemap = get_parent()
	tilemap.set_cell(tile_position)
	queue_free()
