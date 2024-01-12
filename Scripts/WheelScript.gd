extends RayCast3D
class_name WheelScript

@export var debug : bool
var i = 0
@export_category("Suspension")
@export var rest_lenght : float
@export var spring_stiff : float
@export var damper_stiff : float

@export_category("Wheel")
@export var wheel_radius : float = 0.33
@export var fr_wheel : bool
@export var fl_wheel : bool
@export var traction : bool


@onready var wheel = $WheelCenter

var steer_angles : float

@export_category("Tire")
@export var tire_grip : float
@export var tire_len : float

@onready var car = $".." as CarScript as RigidBody3D

func _ready():
	target_position.y = -(rest_lenght + wheel_radius)
	add_exception(car)


func _physics_process(delta):
	var origin = global_position
	var collision_point = get_collision_point()
	var distance = origin.distance_to(collision_point)
	var force_point = Vector3(collision_point.x, collision_point.y + wheel_radius, collision_point.z)
	

	
	suspension(distance, force_point, delta)
	acceleration(force_point)
	z_force(force_point, delta)
	x_force(force_point, delta)
	steering()
	wheel_rotation()
	
	if Input.is_action_pressed('x'):
		car.apply_force(global_basis.x * car.engine_power, force_point - car.global_position)
		
		
func wheel_rotation():
	if car.linear_velocity.dot(basis.z) > 0:
		wheel.rotation_degrees.x -= car.speedkmh / 3.6
	else:
		wheel.rotation_degrees.x += car.speedkmh / 3.6

func steering():
	rotation_degrees.y = steer_angles
	
func x_force(force_point, delta):
	if is_colliding():
		var dir = global_basis.x
		var world_tire_vel = get_point_velocity(global_position)
		var vel = dir.dot(world_tire_vel)
		var force = -vel * tire_grip
		var xforce = force / delta
		
		car.apply_force(dir * xforce, force_point - car.global_position)
		
		if car.debug:
			DebugDraw3D.draw_arrow_line(global_position, global_position + (dir * ((xforce / 1000) / 10)), Color.RED, 0.1, true)
	
func z_force(force_point, delta):
	if is_colliding():
		var dir = global_basis.z
		var world_tire_vel = get_point_velocity(global_position)
		var vel = dir.dot(world_tire_vel)
		var zforce = (car.mass / car.drag) * vel
		
		if car.speedkmh < 3 and not Input.is_action_pressed("accelerate") and not Input.is_action_pressed("reverse"):
			car.linear_velocity = Vector3.ZERO
			car.angular_velocity = Vector3.ZERO
		elif car.speedkmh < 5 and not Input.is_action_pressed("accelerate") and not Input.is_action_pressed("reverse"):
			car.linear_velocity = lerp(car.linear_velocity, Vector3.ZERO, delta * 1)
			car.angular_velocity = lerp(car.angular_velocity, Vector3.ZERO, delta * 1)
		else:
			car.apply_force(-dir * zforce, force_point - car.global_position)
		if car.debug:
			DebugDraw3D.draw_arrow_line(force_point, force_point + (-dir * ((zforce / 1000) / 2)), Color.BLUE_VIOLET, 0.1, true)
		

func acceleration(force_point):
	if traction and is_colliding():
		var accel_dir = -global_basis.z
		var torque = car.accel_input * car.engine_power
		car.apply_force(accel_dir * torque, force_point - car.global_position)
		if car.debug:
			DebugDraw3D.draw_arrow_line(force_point, force_point - (accel_dir * ((torque / 1000) / 10)), Color.BLUE, 0.1, true)

func suspension(distance, force_point,delta):
	if is_colliding():
		var susp_dir = global_basis.y
		var offset = rest_lenght - distance
		var world_tire_vel = get_point_velocity(global_position)
		var vel = susp_dir.dot(world_tire_vel)
		var suspension_force = (spring_stiff * offset) - (damper_stiff * vel)
		car.apply_force(suspension_force * susp_dir, force_point - car.global_position)
		
		if offset > tire_len:
			wheel.position.y = position.y -(tire_len)
		else:
			wheel.position.y = (position.y -(tire_len) + (offset))
			
		if debug:
			if traction:
				DebugDraw3D.draw_sphere(force_point, 0.1)
			DebugDraw3D.draw_arrow_line(global_position, to_global(position + Vector3(-position.x, ((suspension_force / 1000) / 1.5), -position.z)), Color.GREEN, 0.1, true)
			DebugDraw3D.draw_line_hit_offset(global_position, Vector3(global_position.x, global_position.y - distance, global_position.z), true, 1, 0.25, Color.RED, Color.RED)
	else:
			wheel.position.y = position.y -(tire_len)
		
func get_point_velocity(point : Vector3) -> Vector3:
	return car.linear_velocity + car.angular_velocity.cross(point - car.global_position)
