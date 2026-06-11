extends AnimatedSprite2D

@onready var left_detector: RayCast2D = $LeftDetector
@onready var right_detector: RayCast2D = $RightDetector

const SPEED = 25.0
const MIN_SECONDS: int = 3
const MAX_SECONDS: int = 5

enum Direction {LEFT = -1, RIGHT = 1}

var current_direction: Direction = Direction.RIGHT
var is_walking: bool = false

func _ready() -> void:
	self.play('idle')

func _process(delta: float) -> void:
	if ((current_direction == Direction.LEFT and not left_detector.is_colliding()) or
		(current_direction == Direction.RIGHT and not right_detector.is_colliding())):
		turn_around()
	if not is_walking:
		start_roam_timer(delta)
	elif animation == 'walk':
		position.x += current_direction * SPEED * delta

func start_roam_timer(_delta: float) -> void:
	is_walking = true
	self.play('walk')
	var random_float = randf_range(MIN_SECONDS, MAX_SECONDS)
	await get_tree().create_timer(random_float).timeout
	start_idle_timer()

func start_idle_timer() -> void:
	self.play('idle')
	var random_float = randf_range(MIN_SECONDS, MAX_SECONDS)
	await get_tree().create_timer(random_float).timeout
	if randi_range(0, 1) == 0:
		turn_around()
	is_walking = false

func turn_around() -> void:
	if current_direction == Direction.LEFT:
		current_direction = Direction.RIGHT
		flip_h = false
	else:
		current_direction = Direction.LEFT
		flip_h = true
