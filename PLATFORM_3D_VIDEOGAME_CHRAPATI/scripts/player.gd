extends CharacterBody3D

@export var speed = 14.0
@export var fall_acceleration = 75.0
@export var jump_impulse = 20.0
@export var max_health = 100

@onready var _camera := $CameraPivot/SpringArm3D/TPSCamera as Camera3D
@onready var _camera_pivot := $CameraPivot as Node3D

@onready var spring_arm = $CameraPivot/SpringArm3D

@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)

@export var joystick_deadzone = 0.15

var current_health = max_health
var target_velocity = Vector3.ZERO

signal health_changed(current, max)
signal died
signal pause_game

func _ready():
	emit_signal("health_changed", current_health, max_health)

func take_damage(amount):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", current_health, max_health)
	
	if current_health == 0:
		emit_signal("died")

func heal(amount):
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", current_health, max_health)

func pause_player():
	emit_signal("pause_game")

func _physics_process(delta):
	# Camera control
	var joy_index = 0
	var axis_x = Input.get_joy_axis(joy_index, JOY_AXIS_RIGHT_X)
	var axis_y = Input.get_joy_axis(joy_index, JOY_AXIS_RIGHT_Y)
	
	if abs(axis_x) > joystick_deadzone or abs(axis_y) > joystick_deadzone:
		_camera_pivot.rotation.x -= axis_y * mouse_sensitivity * 5.0
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		_camera_pivot.rotation.y += axis_x * mouse_sensitivity * 5.0
	
	# Gravity condition
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta
	
	# Jump action
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# Direction control
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Pause menu
	if Input.is_action_pressed("pause"):
		pause_player()
	
	# Relative camera direction
	var camera_forward = _camera.global_transform.basis.z
	camera_forward.y = 0
	camera_forward = camera_forward.normalized()
	var camera_right = _camera.global_transform.basis.x
	
	if direction != Vector3.ZERO:
		var movement_direction = (camera_right * direction.x + camera_forward * direction.z).normalized()
		target_velocity.x = movement_direction.x * speed
		target_velocity.z = movement_direction.z * speed
	else:
		# Decelerate the movement
		target_velocity.x = move_toward(target_velocity.x, 0, speed)
		target_velocity.z = move_toward(target_velocity.z, 0, speed)
	
	# Movement
	velocity = target_velocity
	move_and_slide()
	
	# Damage if falling
	if global_position.y < -10:
		take_damage(100)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		# Prevent the camera from rotating too far up or down.
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		_camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity
	
