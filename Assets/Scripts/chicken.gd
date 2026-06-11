extends "res://Assets/Scripts/walking_animal.gd"

const MIN_PECK_SECONDS: int = 1
const MAX_PECK_SECONDS: int = 2

func _ready() -> void:
	super._ready()
	animation_changed.connect(_on_animation_changed)

func _on_animation_changed() -> void:
	if animation == 'idle':
		start_peck_loop()

func start_peck_loop() -> void:
	await get_tree().create_timer(randf_range(MIN_PECK_SECONDS, MAX_PECK_SECONDS)).timeout
	if animation == 'idle':
		self.play('peck')
		await animation_finished
		self.play('idle')
