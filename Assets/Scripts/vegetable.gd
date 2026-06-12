extends "res://Assets/Scripts/pickupable.gd"

class_name Vegetable

var _type: VegetableType

enum VegetableType {BEET, CARROT, ONION}

func get_vegetable_type() -> String:
	return VegetableType.keys()[_type]
