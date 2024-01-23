extends RayCast3D
class_name WheelScript

@onready var driving_states = $"../Driving States"

@export var debug : bool

@export_category("Suspension")
@export var rest_lenght : float
@export var spring_stiff : float
@export var damper_stiff : float

@export_category("Wheel")
@export var wheel_radius : float = 0.33
@export var fr_wheel : bool
@export var fl_wheel : bool
@export var traction : bool
@export_range(0.0, 0.5) var anti_roll_factor : float

var force_point : Vector3
@onready var wheel : Node3D

var steer_angles : float

@export_category("Tire")
@export var tire_mass : float
@export var grip_factor : float
@export var tire_len : float
@export var inv_tire_rot : bool
var grounded : bool

@onready var car = $".." as CarScript as RigidBody3D

func _ready():
	wheel = get_child(0)
	target_position.y = -(rest_lenght + wheel_radius)
	add_exception(car)


func _physics_process(delta):
	var origin = global_position
	var collision_point = get_collision_point()
	var distance = origin.distance_to(collision_point)
	force_point = Vector3(collision_point.x, (collision_point.y + wheel_radius) + anti_roll_factor, collision_point.z)
	if is_colliding():
		grounded = true
	else:
		grounded = false

	
	suspension(distance, force_point, delta)
	z_force(force_point, delta)
	x_force(force_point, delta)
	steering()
	wheel_rotation()
	
	
func wheel_rotation():
	if inv_tire_rot:
		if car.zmotion > 0:
			wheel.rotation_degrees.x -= car.speedkmh / 3.6
		elif car.zmotion < 0:
			wheel.rotation_degrees.x += car.speedkmh / 3.6
	else:
		if car.zmotion > 0:
			wheel.rotation_degrees.x += car.speedkmh / 3.6
		elif car.zmotion < 0:
			wheel.rotation_degrees.x -= car.speedkmh / 3.6
			
func steering():
	rotation_degrees.y = steer_angles
	
func x_force(force_point, delta):
	if is_colliding():
		var dir = global_basis.x
		var world_tire_vel = get_point_velocity(global_position)
		var vel = dir.dot(world_tire_vel)
		if traction:
			grip_factor = car.traction_curve.sample_baked(abs(vel) / world_tire_vel.length())
		else:
			grip_factor = car.steer_curve.sample_baked(abs(vel) / world_tire_vel.length())
		var force = -vel * grip_factor
		var xforce = force / delta
		
		car.apply_force(dir * tire_mass * xforce, force_point - car.global_position)
		
		if car.debug:
			DebugDraw3D.draw_arrow_line(global_position, global_position + (dir * ((xforce / 100))), Color.RED, 0.1, true)
	
func z_force(force_point, delta):
	if is_colliding():
		var dir = global_basis.z
		var world_tire_vel = get_point_velocity(global_position)
		var vel = dir.dot(world_tire_vel)
		var zforce = (car.mass / car.drag) * vel
		
		#if car.speedkmh < 3 and driving_states.current_state == IdleState:
			#car.linear_velocity = Vector3.ZERO
			#car.angular_velocity = Vector3.ZERO
		if car.speedkmh < 5:
			car.linear_velocity = lerp(car.linear_velocity, Vector3.ZERO, delta * 1)
			#car.angular_velocity = lerp(car.angular_velocity, Vector3.ZERO, delta * 1)
		else:
			car.apply_force(-dir * zforce, force_point - car.global_position)
		if car.debug:
			DebugDraw3D.draw_arrow_line(force_point, force_point + (-dir * ((zforce / 1000) / 2)), Color.BLUE_VIOLET, 0.1, true)
		
func suspension(distance, force_point,delta):
	if is_colliding():
		var susp_dir = global_basis.y
		var offset = rest_lenght - distance
		var world_tire_vel = get_point_velocity(global_position)
		var vel = susp_dir.dot(world_tire_vel)
		var suspension_force = (spring_stiff * offset) - (damper_stiff * vel)
		car.apply_force(suspension_force * susp_dir, force_point - car.global_position)
		
		var wheel_pos_on_col = to_local(Vector3(global_position.x, get_collision_point().y + wheel_radius, global_position.z))
		wheel.position.y = wheel_pos_on_col.y
			
	
		if car.debug:
			if traction:
				DebugDraw3D.draw_sphere(force_point, 0.1)
			DebugDraw3D.draw_arrow_line(global_position, to_global(position + Vector3(-position.x, ((suspension_force / 1000) / 1.5), -position.z)), Color.GREEN, 0.1, true)
			DebugDraw3D.draw_line_hit_offset(global_position, Vector3(global_position.x, global_position.y - distance, global_position.z), true, 1, 0.25, Color.RED, Color.RED)
	else:
			wheel.position.y = position.y -(wheel_radius + 0.05)
		
func get_point_velocity(point : Vector3) -> Vector3:
	return car.linear_velocity + car.angular_velocity.cross(point - car.global_position)
