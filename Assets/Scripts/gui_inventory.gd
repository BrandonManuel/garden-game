extends HBoxContainer

func _ready() -> void:
	Inventory.item_added.connect(_on_item_added)

func _on_item_added(item: PickupableData) -> void:
	var new_rect = TextureRect.new()
	new_rect.texture = item.icon
	new_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	new_rect.custom_minimum_size = Vector2(64, 64) 
	add_child(new_rect)
