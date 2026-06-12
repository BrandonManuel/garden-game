extends Node

var _inventory: Array[PickupableData] = []

signal item_added(item: PickupableData)

func add(pickupable: PickupableData) -> void:
	_inventory.append(pickupable)
	item_added.emit(pickupable)
