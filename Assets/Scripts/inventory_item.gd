extends HBoxContainer

class_name InventoryItem

var _data: PickupableData
var _icon: TextureRect
var _label: Label

var num_items: int

func _init(item: PickupableData):
	_data = item
	
	_icon = TextureRect.new()
	_icon.texture = _data.icon
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_icon.custom_minimum_size = Vector2(64, 64)
	
	num_items = 0

	_label = Label.new()
	
	add_child(_icon)
	add_child(_label)

func _process(delta: float) -> void:
	_label.text = "%d" % num_items
