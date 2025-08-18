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

#var current_steering: float = 0.0  # Current steering angle
#var fire_timer: float = 0.0        # Cooldown timer for shooting

@onready var ray_start_position_local = Vector3(0, 0, 0) # Local to this RigidBody3D
var ray_length = 1.0 # 1 unit downward
var ray_color = Color.RED # Default to red

var points: Array[Node3D]
var up_force = mass * 500

func _ready() -> void:
	points.append($Node3D)
	points.append($Node3D2)
	points.append($Node3D3)
	points.append($Node3D4)
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			up_force += 1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			up_force -= 1
			
	print(up_force)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		apply_upward_force(Vector3(randf() * 2 - 1, randf() * 2 - 1, randf() * 2 - 1), 100, 1)
		
	# Handle tank movement
	var forward_input = Input.get_axis("down", "up")  # W/S for forward/backward
	var steer_input = Input.get_axis("right", "left")  # A/D for steering
	
	#apply_force(-transform.basis.z.normalized() * forward_input * max_engine_force)
	#apply_torque(Vector3.UP * steer_input * 6000000)
	
	DebugDraw3D.clear_all()
	
	#for point in points:
		#DebugDraw3D.draw_sphere(point.position, 0.5, Color(255,0,0))
	
	# Get the object's local "down" direction in global space
	# The 'basis' property of a Transform contains the orientation vectors.
	# basis.y is the object's loray_start_position_localcal Y-axis. We want the negative Y (down).
	var local_down_direction_global = -global_transform.basis.y.normalized()

	for point in points:
		# Calculate the ray's start point in GLOBAL space
		var global_ray_start = global_transform * point.position

		# Calculate the ray's end point in GLOBAL space,
		# moving along the object's local "down" direction
		var global_ray_end = global_ray_start + (local_down_direction_global * ray_length)

		# Create a PhysicsRayQueryParameters3D object
		var query = PhysicsRayQueryParameters3D.new()
		query.from = global_ray_start
		query.to = global_ray_end
		query.exclude = [self.get_rid()] # Exclude self from collision

		# Perform the raycast
		var space_state = get_world_3d().direct_space_state
		var result = space_state.intersect_ray(query)

		if result:
			# Ray hit something
			ray_color = Color.GREEN
			# Draw a sphere at the hit location using DebugDraw3D
			DebugDraw3D.draw_sphere(result.position, 0.05, Color.BLUE, false) # position, radius, color, no_depth_test
			# You can get the distance if needed
			var distance = global_ray_start.distance_to(result.position)
			DebugDraw3D.draw_text(point.global_position, "%.2f" % distance, 72)
			apply_upward_force(point.position, 1-distance * up_force, -1)
			 #print("Ray hit at:", result.position, "Distance:", distance)
		else:
			# Ray didn't hit anything
			ray_color = Color.RED

		# Draw the ray line using DebugDraw3D (expects global coordinates)
		DebugDraw3D.draw_line(global_ray_start, global_ray_end, ray_color, 2.0) # start_point, end_point, color, thickness, no_depth_test


func apply_upward_force(position: Vector3, magnitude: float, direction: int):
	var local_up_direction = transform.basis.y * direction
	var force_vector = local_up_direction * magnitude
	apply_force(force_vector, position)
	
	
func _shoot() -> void:
	pass
	#var bullet = bullet_scene.instantiate()
	#get_tree().root.add_child(bullet)
	#bullet.global_transform = muzzle.global_transform
	#bullet.linear_velocity = -muzzle.global_transform.basis.z * bullet_speed
