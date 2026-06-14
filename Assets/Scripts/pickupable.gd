extends Area2D
class_name Pickupable

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var data: Resource

var tile_position

func _ready():
	var tilemap = get_parent()
	tile_position = tilemap.local_to_map(position)
	sprite_2d.material = sprite_2d.material.duplicate()
	
func set_outline(enabled: bool) -> void:
	sprite_2d.material.set_shader_parameter("outline_enabled", enabled)

func picked_up() -> void :
	remove_from_group('pickupables')
	set_outline(false)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite_2d,"position", Vector2.UP * 5, .5).as_relative().set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(sprite_2d,"region_rect", Rect2(0, 0, 16.0, 32.0), .5).set_trans(Tween.TRANS_LINEAR)

	tween.tween_callback(clear)

func clear():
	await get_tree().create_timer(.5).timeout
	var tilemap = get_parent()
	tilemap.set_cell(tile_position)
	Inventory.add(data)
	queue_free()
