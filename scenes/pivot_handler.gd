extends Node3D

@onready var pivot = %pivot
@onready var mouse_sens := 0.09
@onready var mouse_visible := false
# Called when the node enters the scene tree for the first time.

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	
	# handles mouse movement
	
	if event is InputEventMouseMotion and ! mouse_visible:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		
	
	# handles mouse movement
	
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
