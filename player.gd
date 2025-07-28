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
		
		apply_impulse(Vector3.UP * 3, Vector3(randf() * 2 - 1, randf() * 2 - 1, randf() * 2 - 1))
		
	# Handle tank movement
	var forward_input = Input.get_axis("down", "up")  # W/S for forward/backward
	var steer_input = Input.get_axis("right", "left")  # A/D for steering
	
	#apply_force(-transform.basis.z.normalized() * forward_input * max_engine_force)
	#
	#apply_torque(Vector3.UP * steer_input * 6000000)


func _shoot() -> void:
	pass
	#var bullet = bullet_scene.instantiate()
	#get_tree().root.add_child(bullet)
	#bullet.global_transform = muzzle.global_transform
	#bullet.linear_velocity = -muzzle.global_transform.basis.z * bullet_speed
