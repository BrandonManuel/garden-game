extends Area2D
class_name PickupableContainer

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var data: PickupableContainerData
@export var max_num_pickupables: int
@export var pickupable_scene: PackedScene

@onready var pickupables: Area2D = $Pickupables

var num_pickupables: int
var radius: float
var height: float
var pickupables_x: float
var pickupables_y: float

var tile_position

func _ready():
	var tilemap = get_parent()
	tile_position = tilemap.local_to_map(position)
	if sprite_2d.material != null:
		sprite_2d.material = sprite_2d.material.duplicate()
	
	var collision = pickupables.get_node("CollisionShape2D")
	
	var shape = collision.shape
	if shape is CapsuleShape2D:
		radius = shape.radius
		height = shape.height
		pickupables_x = pickupables.position.x
		pickupables_y = pickupables.position.y
	
	num_pickupables = randi_range(0, max_num_pickupables)
	for i in num_pickupables:
		var pickupable: Pickupable = pickupable_scene.instantiate()
		
		# since capsule is horizontal, use height for x and radius for y
		var random_x: float = randf_range(-height * .5, height * .5)
		var random_y: float = randf_range(-radius * .5, radius * .5)
		var random_image_index: int = randi_range(0, data.num_frames - 1)
		
		add_child(pickupable)
		pickupable.sprite_2d.scale = Vector2(1, 1)
		pickupable.sprite_2d.position.x = pickupables_x + random_x
		pickupable.sprite_2d.position.y = pickupables_y + random_y
		pickupable.sprite_2d.frame = random_image_index
		
	
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
	#Inventory.add(data)
	queue_free()
