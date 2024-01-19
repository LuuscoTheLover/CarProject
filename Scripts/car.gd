extends RigidBody3D
class_name CarScript

@export var debug : bool

@export_category("Engine")
@export var horse_power : float
@export var acceleration_curve : Curve = null
@export var brake_force : float

var max_speed : float
var wheel_rpm : float
var rpm : float

@export_category("Gears")
@export var max_speed_gear : Array[float]
@export var gear_ratio : Array[float]
@export var differential_ratio : float
@export var current_gear : float = 0

@export_category("Wheels")
@export var steer_curve : Curve = null
@export var traction_curve : Curve = null
@export var RRWheel : WheelScript
@export var RLWheel : WheelScript

@export_category("Car Specs")
@export var wheel_base : float
@export var turn_radius : float
@export var rear_track : float
@export var drag : float = 10




var rear_gear : bool

@onready var steer_component = $SteerComponent as SteerComponent

var speedmps : float
var speedkmh : float
var accel_input : float
var reverse_input : float

func _process(delta):
	reset()
	car_reverse_checker()
	speed_checker()
	input_checker()
	wheel_rpm_checker(delta)
	
	max_speed = max_speed_gear[current_gear] / 3.6
	
	
func wheel_rpm_checker(delta):
	wheel_rpm = ( speedmps * 60) / (2 * PI * (RRWheel.wheel_radius))
	var w_rpm = wheel_rpm * differential_ratio * gear_ratio[current_gear]
	

func input_checker():
	accel_input = Input.get_action_strength("accelerate") * (horse_power * 160)
	reverse_input = Input.get_action_strength("reverse") * brake_force
	steer_component.steering_input = -Input.get_axis("left", "right")

func car_reverse_checker():
	if linear_velocity.dot(basis.z) > 1:
		rear_gear = true
	else:
		rear_gear = false

func speed_checker():
	speedmps = linear_velocity.length()
	speedkmh = int(speedmps * 3.6)

func reset():
	if Input.is_action_just_pressed("reset"):
		global_position.y += 7
		rotation_degrees = Vector3.ZERO
		
