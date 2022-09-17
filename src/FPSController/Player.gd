extends CharacterBody3D
#Created by elmarcoh . License: The Unlicense. This project is from here: https://github.com/elmarcoh/fps-controller-godot
@onready var camRoot = $CameraRoot
@onready var camera = $CameraRoot/Camera3D
@onready var raycast = $CameraRoot/Camera3D/RayCast3D
@onready var scppos = $Marker3d

var vel = Vector3.ZERO
var current_vel = Vector3.ZERO
var direction = Vector3.ZERO

const MOUSE_SENSITIVITY = 0.1
const SPEED = 4.5
const SPRINT_SPEED = 7
const ACCEL = 15.0

const GRAVITY = -40.0
const JUMP_SPEED = 6
const AIR_ACCEL = 9.0

var jump_counter = 0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Common.player = self

func _input(event):
	if event is InputEventMouseMotion:
		camRoot.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		camRoot.rotation.x = clamp(camRoot.rotation.x, -75, 75)
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))

func _process(delta):
	window_activity()

func window_activity():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	direction = Vector3.ZERO
	
	if Input.is_action_pressed("fwd"):
		direction -= camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		direction += camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		direction -= camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		direction += camera.global_transform.basis.x
	
	direction = direction.normalized()
	
	#jump
	velocity.y += GRAVITY * delta
	if is_on_floor():
		jump_counter = 0
		
	if Input.is_action_just_pressed("jump") and jump_counter < 1:
		jump_counter += 1
		velocity.y = JUMP_SPEED
	
	var speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else SPEED
	var target_vel = direction * speed
	
	var accel = ACCEL if is_on_floor() else AIR_ACCEL
	
	current_vel = \
		current_vel.lerp(target_vel, accel * delta)
	velocity.x = current_vel.x
	velocity.z = current_vel.z
	set_velocity(velocity)
	set_up_direction(Vector3.UP)
	set_floor_stop_on_slope_enabled(true)
	set_max_slides(4)
	set_floor_max_angle(deg_to_rad(45))
	move_and_slide()
	velocity = velocity
