extends RayCast3D
class_name Wheel

@export_category("Suspension")
@export var spring_stiffness : float
@export var spring_travel : float
@export var rest_lenght : float
@export var damper_stiffness : float

var spring_lenght : float
var max_lenght : float
var min_lenght : float


@export_category("Wheel")
@export var fr_wheel : bool
@export var fl_wheel : bool
@export var traction : bool
@export var wheel_radius : float


var ackerman_left : float
var ackerman_right : float

@export_category("Tires")
@export var tire_grip : float
@export var tire_mass : float


var steer_dir : float

@onready var car: Car = $".." as Car


func _ready():
	max_lenght = rest_lenght + spring_travel
	min_lenght = rest_lenght - spring_travel
	
	
func _process(delta):
	steer_dir = -Input.get_axis("left", "right")

func _physics_process(delta):
	target_position.y = -(max_lenght + wheel_radius) 
	
	var point = Vector3(get_collision_point().x, get_collision_point().y + wheel_radius, get_collision_point().z)
	var origin = global_position
	var destin = get_collision_point()
	var distance = origin.distance_to(destin)
	
	suspension(distance, point, delta)
	lateral_tire_grip(distance, point, delta)
	steering()
	
	if traction:
		car.apply_force(global_basis.z * 15000 * Input.get_axis("reverse", "acceleration"), point - car.global_position)


func steering():
	if steer_dir > 0:
		ackerman_right = rad_to_deg(atan(car.wheel_base / (car.turn_radius + (car.rear_track / 2))) * steer_dir)
		ackerman_left = rad_to_deg(atan(car.wheel_base / (car.turn_radius - (car.rear_track / 2))) * steer_dir)
	elif steer_dir < 0:
		ackerman_right = rad_to_deg(atan(car.wheel_base / (car.turn_radius - (car.rear_track / 2))) * steer_dir)
		ackerman_left = rad_to_deg(atan(car.wheel_base / (car.turn_radius + (car.rear_track / 2))) * steer_dir)
	else:
		ackerman_right = 0
		ackerman_left = 0
	if fr_wheel:
		rotation_degrees.y = ackerman_right
	if fl_wheel:
		rotation_degrees.y = ackerman_left

func suspension(distance, point, delta):
	if is_colliding():
		var last_lenght = spring_lenght
		var direction = global_basis.y
		spring_lenght = distance - wheel_radius
		var spring_force = spring_stiffness * (rest_lenght - spring_lenght)
		var velocity = (last_lenght - spring_lenght) / delta
		var suspension_force = (spring_force) + (damper_stiffness * velocity)
		
		car.apply_force(suspension_force * direction, point - car.global_position)

func lateral_tire_grip(distance, point, delta):
	if is_colliding():
		var x_force = global_basis.x
		var world_tire_velocity = get_point_velocity(global_position)
		var vel = x_force.dot(world_tire_velocity)
		var change = -vel * tire_grip
		var des_change = change / delta
		car.apply_force(x_force * des_change * tire_mass, point - car.global_position)
		
func get_point_velocity(point : Vector3) -> Vector3:
	return car.linear_velocity + car.angular_velocity.cross(point - car.global_transform.origin)
