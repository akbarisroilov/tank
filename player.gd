extends RigidBody3D


var engine_hp_to_force_factor = 2.0

@export var engine_horsepower: float = 800.0 # 1 hp = 745.7 watts
@export var max_engine_force: float = engine_horsepower * 745.7 * engine_hp_to_force_factor
@export var max_brake_force: float = 50.0   # Maximum braking force
@export var max_steering: float = 0.5       # Maximum steering angle (radians)
@export var steering_speed: float = 18.0 # degrees per second
@export var turret_rotation_speed: float = 100.0  # Turret rotation speed (degrees/sec)
@export var barrel_pitch_speed: float = 50.0      # Barrel pitch speed (degrees/sec)
@export var barrel_pitch_min: float = -10.0       # Min barrel pitch (degrees)
@export var barrel_pitch_max: float = 20.0        # Max barrel pitch (degrees)
@export var bullet_speed: float = 50.0           # Speed of the projectile
@export var fire_cooldown: float = 1.0           # Time between shots (seconds)

#@onready var turret: Node3D = $Turret
#@onready var barrel: Node3D = $Turret/Barrel
#@onready var muzzle: Node3D = $Turret/Barrel/Muzzle
#var bullet_scene: PackedScene = preload("res://Bullet.tscn")  # Path to bullet scene

var current_steering: float = 0.0  # Current steering angle
var fire_timer: float = 0.0        # Cooldown timer for shooting

func _ready() -> void:
	# Ensure the turret and barrel are properly aligned initially
	#turret.rotation = Vector3.ZERO
	#barrel.rotation = Vector3.ZERO
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		# Apply impulse upward (Y-axis)
		apply_impulse(Vector3.UP * 260000, Vector3.ZERO)
		
	# Handle tank movement
	var forward_input = Input.get_axis("down", "up")  # W/S for forward/backward
	var steer_input = Input.get_axis("right", "left")  # A/D for steering
	
	apply_force(-transform.basis.z.normalized() * forward_input * max_engine_force)
	
	apply_torque(Vector3.UP * steer_input * 2000)
		
	# Apply engine force for movement
	#engine_force = forward_input * max_engine_force
	#brake = Input.is_action_pressed("ui_select") * max_brake_force  # Space for braking

	# Smoothly interpolate steering
	#current_steering = lerp(current_steering, steer_input * max_steering, steering_speed * delta)
	#steering = current_steering

	# Handle turret rotation (horizontal, yaw)
	#if Input.is_action_pressed("turret_left"):
		#turret.rotate_y(deg_to_rad(turret_rotation_speed) * delta)
	#if Input.is_action_pressed("turret_right"):
		#turret.rotate_y(-deg_to_rad(turret_rotation_speed) * delta)

	# Handle barrel pitch (vertical)
	#var pitch_input = Input.get_axis("barrel_down", "barrel_up")  # I/K or custom keys
	#var pitch_change = pitch_input * barrel_pitch_speed * delta
	#var new_pitch = clamp(barrel.rotation_degrees.x + pitch_change, barrel_pitch_min, barrel_pitch_max)
	#barrel.rotation_degrees.x = new_pitch

	# Handle shooting
	#fire_timer -= delta
	#if Input.is_action_just_pressed("fire") and fire_timer <= 0.0:
		#_shoot()
		#fire_timer = fire_cooldown

func _shoot() -> void:
	pass
	#var bullet = bullet_scene.instantiate()
	#get_tree().root.add_child(bullet)
	#bullet.global_transform = muzzle.global_transform
	#bullet.linear_velocity = -muzzle.global_transform.basis.z * bullet_speed
