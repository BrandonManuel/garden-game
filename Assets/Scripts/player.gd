extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var pickup_area: Area2D = $AnimatedSprite2D/Area2D

const WALK_SPEED = 50.0
const RUN_SPEED = 75.0
const JUMP_VELOCITY = -200.0

var pickup_area_x: float
var current_pickupable: Pickupable = null

var is_running: bool = false
var allow_movement: bool = true
var is_picking_up: bool = false

signal toggle_inventory

func _ready() -> void:
	pickup_area_x = pickup_area.position.x
	pickup_area.area_entered.connect(_on_pickup_area_entered)
	pickup_area.area_exited.connect(_on_pickup_area_exited)

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
		
	# Handle inventory.
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
		
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
			pickup_area.position.x = pickup_area_x * -1
		else:
			animated_sprite_2d.flip_h = false
			pickup_area.position.x = pickup_area_x
	elif not animated_sprite_2d.is_playing() or animated_sprite_2d.animation != 'pick_up':
		animated_sprite_2d.play('idle')
		velocity.x = move_toward(velocity.x, 0, RUN_SPEED if is_running else WALK_SPEED)


	move_and_slide()

func attempt_pickup() -> void:
	if is_picking_up or current_pickupable == null or not current_pickupable.is_in_group("pickupables") or not current_pickupable.has_method("picked_up"):
		return
	
	is_picking_up = true
	allow_movement = false
	velocity.x = move_toward(velocity.x, 0, RUN_SPEED if is_running else WALK_SPEED)
	animated_sprite_2d.play("pick_up")
	current_pickupable.picked_up()
	current_pickupable = null
	find_next_pickupable()

func find_next_pickupable() -> void:
	for area in pickup_area.get_overlapping_areas():
		if area is Pickupable and area.is_in_group("pickupables"):
			current_pickupable = area
			current_pickupable.set_outline(true)
			break

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == 'pick_up':
		allow_movement = true
		is_picking_up = false

func _on_pickup_area_entered(area: Area2D) -> void:
	if area is Pickupable and current_pickupable == null:
		current_pickupable = area
		current_pickupable.set_outline(true)
		
func _on_pickup_area_exited(area: Area2D) -> void:
	if area is Pickupable and current_pickupable == area:
		current_pickupable = null
		area.set_outline(false)
		find_next_pickupable()
