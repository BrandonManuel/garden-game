extends HBoxContainer

@onready var inventory_container: VBoxContainer = $".."

func _ready() -> void:
	visible = false
	Inventory.item_added.connect(_on_item_added)

func _on_item_added(item: PickupableData) -> void:
	var new_rect = TextureRect.new()
	new_rect.texture = item.icon
	new_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	new_rect.custom_minimum_size = Vector2(64, 64) 
	add_child(new_rect)

func _hide_ui_element(ui_element) -> bool:
	ui_element.visible = !ui_element.visible
	return true

func _on_player_toggle_inventory() -> void:
	inventory_container.get_children(true).all(_hide_ui_element)
