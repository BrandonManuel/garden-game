extends "res://Assets/Scripts/pickupable.gd"

class_name Fruit

var _type: FruitType

enum FruitType {Apple}

func get_fruit_type() -> String:
	return FruitType.keys()[_type]
