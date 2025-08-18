extends Node3D

@export var target: Node3D  # The vehicle to follow
@export var mouse_sensitivity: float = 0.3  # Mouse sensitivity for camera rotation
@export var distance: float = 5.0  # Desired distance from the vehicle
@export var min_distance: float = 2.0  # Minimum camera distance
@export var max_distance: float = 15.0  # Maximum camera distance
@export var zoom_speed: float = 0.5  # How much distance changes per scroll
@export var zoom_smoothing: float = 5.0  # Smoothing factor for zoom (lower = smoother)
@export var pitch_min: float = -80.0  # Minimum pitch angle (degrees)
@export var pitch_max: float = 60.0  # Maximum pitch angle (degrees)
@export var follow_speed: float = 5.0  # How fast the camera follows the vehicle

var yaw: float = 0.0  # Horizontal rotation
var pitch: float = 0.0  # Vertical rotation
var current_distance: float = 0.0  # Current camera distance (adjusted by zoom)
var target_distance: float = 0.0  # Target distance for smooth zooming

@onready var camera: Camera3D = $Camera3D  # Reference to the Camera3D node

func _ready() -> void:
	if not target:
		target = get_parent()  # Assume parent (Vehicle) is the target if not set
	current_distance = distance
	target_distance = distance
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture mouse for camera control

func _input(event: InputEvent) -> void:
	# Handle mouse motion for camera rotation
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, pitch_min, pitch_max)

	# Handle mouse scroll for zooming
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			#target_distance = clamp(target_distance - zoom_speed, min_distance, max_distance)
		#if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			#target_distance = clamp(target_distance + zoom_speed, min_distance, max_distance)

func _physics_process(delta: float) -> void:
	# Smoothly interpolate the CameraHolder's position to follow the vehicle
	var target_position = target.global_transform.origin
	global_transform.origin = global_transform.origin.lerp(target_position, follow_speed * delta)

	# Apply yaw and pitch to the CameraHolder's rotation
	var rotation_quat = Quaternion(Vector3.UP, deg_to_rad(yaw)) * Quaternion(Vector3.RIGHT, deg_to_rad(pitch))
	global_transform.basis = Basis(rotation_quat)

	# Smoothly interpolate the current distance toward the target distance
	current_distance = lerp(current_distance, target_distance, zoom_smoothing * delta)

	# Update camera position based on distance
	var desired_position = Vector3(0, 0, current_distance)
	camera.transform.origin = desired_position
