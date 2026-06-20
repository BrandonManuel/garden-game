extends Area2D
class_name PickupableContainer

var shader_path = preload("res://Assets/Shaders/interactable.gdshader")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var pickupables: Area2D = $Pickupables

@export var data: PickupableContainerData
@export var max_num_pickupables: int
@export var min_num_pickupables: int
@export var pickupable_scene: PackedScene


var num_pickupables: int
var radius: float
var height: float
var pickupables_x: int
var pickupables_y: int
var placed_positions: Array[Vector2] = []
var min_distance: float = 8.0

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
		pickupables_x = floori(pickupables.position.x)
		pickupables_y = floori(pickupables.position.y)
	
	num_pickupables = randi_range(min_num_pickupables, max_num_pickupables)
	var num_placed := 0
	var attempts := 0
	var max_attempts := num_pickupables * 30

	while num_placed < num_pickupables and attempts < max_attempts:
		attempts += 1
		# since capsule is horizontal, use height for x and radius for y
		var random_x: int = floori(randi_range(-height * .45, height * .45)) + pickupables_x
		var random_y: int = floori(randi_range(-radius * .45, radius * .45)) + pickupables_y
		
		var candidate := Vector2(random_x, random_y)

		var overlapping := false
		for pos in placed_positions:
			if candidate.distance_to(pos) < min_distance:
				overlapping = true
				break			
		
		if overlapping:
			continue
		
		placed_positions.append(candidate)
		var random_image_index: int = randi_range(0, data.num_frames - 1)
		
		var pickupable: Pickupable = pickupable_scene.instantiate()
		add_child(pickupable)
		pickupable.sprite_2d.scale = Vector2(1, 1)
		pickupable.sprite_2d.position.x = random_x
		pickupable.sprite_2d.position.y = random_y
		pickupable.sprite_2d.frame = random_image_index
		
		num_placed += 1
		
	
func set_outline(enabled: bool) -> void:
	sprite_2d.material.set_shader_parameter("outline_enabled", enabled)
	for pickupable in get_children():
		if pickupable is Pickupable:
			var shader_material := ShaderMaterial.new()
			shader_material.shader = shader_path
			pickupable.sprite_2d.material = shader_material
			pickupable.sprite_2d.material.set_shader_parameter("outline_enabled", enabled)

func picked_up() -> void :
	remove_from_group('pickupables')
	set_outline(false)
	var animation_tween = get_tree().create_tween()
	animation_tween.tween_property(sprite_2d, "frame", 8, 1.0)
	clear()

func clear():
	for pickupable in get_children():
		if pickupable is Pickupable:
#			.lift() plays animation but also then adds the data after when it calls internal .clear()
			pickupable.lift()
			num_pickupables -= 1
