extends RayCast3D
class_name WheelScript

@onready var driving_states = $"../Driving States"

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

var world_tire_vel : Vector3
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
	add_exception(car)
	wheel = get_child(0)
	target_position.y = -(rest_lenght + wheel_radius)


func _physics_process(delta):
	var distance = global_position.distance_to(get_collision_point())
	force_point = Vector3(get_collision_point().x, (get_collision_point().y + wheel_radius) + anti_roll_factor, get_collision_point().z)
	grounded = is_colliding()
	world_tire_vel = get_point_velocity(global_position)
	wheel.position.y = position.y - wheel_radius
	
	steering()
	wheel_rotation()
	
	if is_colliding():
		wheel.position.y = (to_local(Vector3(global_position.x, get_collision_point().y + wheel_radius, global_position.z))).y
		grip_force(force_point, delta)
		drag_force(force_point, delta)
		suspension(distance, force_point, delta)
	
func steering():
	rotation_degrees.y = steer_angles
	
func wheel_rotation():
	wheel.rotation_degrees.x += car.zmotion
	if inv_tire_rot:
		wheel.rotation_degrees.x -= car.zmotion
	
func grip_force(force_point, delta):
	var dir = global_basis.x
	var vel = dir.dot(world_tire_vel)
	grip_factor = car.steer_curve.sample_baked(abs(vel) / world_tire_vel.length())
	if traction:
		grip_factor = car.traction_curve.sample_baked(abs(vel) / world_tire_vel.length())
	var lateral_force = ( -vel * grip_factor)/ delta
	print(abs(vel) / world_tire_vel.length())
	car.apply_force(dir * tire_mass * lateral_force, force_point - car.global_position)
	if car.debug:
		DebugDraw3D.draw_arrow_line(global_position, global_position + (dir * ((lateral_force / 100))), Color.RED, 0.1, true)
	
func drag_force(force_point, delta):
	var dir = global_basis.z
	var vel = dir.dot(world_tire_vel)
	var drag_force = (car.mass / car.drag) * vel
	car.apply_force(-dir * drag_force, force_point - car.global_position)
	if car.debug:
		DebugDraw3D.draw_arrow_line(force_point, force_point + (-dir * ((drag_force / 1000) / 2)), Color.BLUE_VIOLET, 0.1, true)

func suspension(distance, force_point,delta):
	var susp_dir = global_basis.y
	var offset = rest_lenght - distance
	var vel = susp_dir.dot(world_tire_vel)
	var suspension_force = (spring_stiff * offset) - (damper_stiff * vel)
	car.apply_force(suspension_force * susp_dir, force_point - car.global_position)
	if car.debug and traction:
		DebugDraw3D.draw_sphere(force_point, 0.1)
		DebugDraw3D.draw_arrow_line(global_position, to_global(position + Vector3(-position.x, ((suspension_force / 1000) / 1.5), -position.z)), Color.GREEN, 0.1, true)
		DebugDraw3D.draw_line_hit_offset(global_position, Vector3(global_position.x, global_position.y - distance, global_position.z), true, 1, 0.25, Color.RED, Color.RED)
	
func get_point_velocity(point : Vector3) -> Vector3:
	return car.linear_velocity + car.angular_velocity.cross(point - car.global_position)
