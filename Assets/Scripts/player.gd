extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var pickup_area: Area2D = $Area2D

const WALK_SPEED = 50.0
const RUN_SPEED = 75.0
const JUMP_VELOCITY = -200.0

var is_running: bool = false
var allow_movement: bool = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle pickup.
	if Input.is_action_just_pressed("pick_up") and is_on_floor():
		attempt_pickup()
		
	is_running = Input.is_action_pressed("run")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("walk_left", "walk_right")
	if allow_movement and direction:
		if is_running:
			animated_sprite_2d.play('run')
			velocity.x = direction * RUN_SPEED
		else:
			animated_sprite_2d.play('walk')
			velocity.x = direction * WALK_SPEED
		if direction < 1:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
	elif not animated_sprite_2d.is_playing() or animated_sprite_2d.animation != 'pick_up':
		animated_sprite_2d.play('idle')
		velocity.x = move_toward(velocity.x, 0, RUN_SPEED if is_running else WALK_SPEED)


	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == 'pick_up':
		allow_movement = true

func attempt_pickup() -> void:
	allow_movement = false
	velocity.x = move_toward(velocity.x, 0, RUN_SPEED if is_running else WALK_SPEED)
	animated_sprite_2d.play("pick_up")
	for area in pickup_area.get_overlapping_areas():
		if area.has_method("picked_up"):
			area.picked_up()
			break
