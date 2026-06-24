extends HBoxContainer

@onready var inventory_container: VBoxContainer = $".."

const divider_icon = preload("res://Assets/Sprites/Inventory Divider.png")
var inventory: Dictionary[PickupableData, InventoryItem] = {}

func _ready() -> void:
	visible = false
	Inventory.item_added.connect(_on_item_added)

func _on_item_added(item: PickupableData) -> void:
	if inventory.get(item) == null:
		_new_item(item)
		
	inventory.get(item).num_items += 1


func _new_item(item: PickupableData) -> void:
	var inventory_item: InventoryItem = InventoryItem.new(item)
	add_child(inventory_item)
	
	inventory[item] = inventory_item
	inventory_item.num_items = 0
	if len(get_children()) > 1:
		var divider: TextureRect  = TextureRect.new()
		divider.texture = divider_icon
		divider.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		divider.custom_minimum_size = Vector2(16, 16)

		add_child(divider)
		move_child(divider, len(get_children()) - 2)
	
func _hide_ui_element(ui_element) -> bool:
	ui_element.visible = !ui_element.visible
	return true

func _on_player_toggle_inventory() -> void:
	inventory_container.get_children(true).all(_hide_ui_element)
