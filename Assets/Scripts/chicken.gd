extends AnimatedSprite2D


const MIN_SECONDS: int = 3
const MAX_SECONDS: int = 5

var is_waiting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_waiting:
		var random_float = randf_range(MIN_SECONDS, MAX_SECONDS) 
		is_waiting = true
		await get_tree().create_timer(random_float).timeout
		self.play('peck')

		
	if not self.is_playing():
		self.play('idle')
		is_waiting = false
