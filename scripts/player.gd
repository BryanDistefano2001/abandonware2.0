extends CharacterBody3D



# vars
@onready var speed_current := 5.0
@onready var pivot = $pivot
@onready var standing_collision_shape = %standing_collision_shape
@onready var crouching_collision_shape = %crouching_collision_shape
@onready var crouch_ray_cast = $crouch_ray_cast
@onready var mouse_visible := true

# player variables
@export var jump_velocity : float
@export var speed_walking : float
@export var speed_crouching : float
@export var speed_sprinting : float
@export var gravity_sens : float
@export var mouse_sens : float
@export var lerp_speed : float
@export var crouch_lerp_speed : float

var direction := Vector3.ZERO
var crouching_depth = -0.5


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	
	# handles mouse movement
	
	if event is InputEventMouseMotion and !mouse_visible:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif Input.is_action_just_pressed("escape") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("escape") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		mouse_visible = true
	else:
		mouse_visible = false
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_sens


	# handles crouching and sprinting logic
	if Input.is_action_pressed("crouch"):
		speed_current = speed_crouching # sets current speed to crouching sped
		pivot.position.y = lerp(pivot.position.y, 1.0 + crouching_depth, delta * crouch_lerp_speed) # crouches character with a lerp
		standing_collision_shape.disabled = true   # standing = true
		crouching_collision_shape.disabled = false # crouching = false
	elif !crouch_ray_cast.is_colliding():
		standing_collision_shape.disabled = false # standing = fase
		crouching_collision_shape.disabled = true # crouching = true
		pivot.position.y = lerp(pivot.position.y, 1.0, delta * crouch_lerp_speed) # stands character up
		if Input.is_action_pressed("sprint"): 
			speed_current = speed_sprinting # obv changes speed to sprint speed
		else:
			speed_current = speed_walking # and back to walking 

	

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor(): # checks if jump = pressed and is on floor
		velocity.y = jump_velocity # velocity gets jump power
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	#direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)
	# direction = 
	
	if direction:
		velocity.x = direction.x * speed_current 
		velocity.z = direction.z * speed_current
		
	else:
		velocity.x = move_toward(velocity.x, 0, speed_current)
		velocity.z = move_toward(velocity.z, 0, speed_current)

	print("el")
	move_and_slide()
