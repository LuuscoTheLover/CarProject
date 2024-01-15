extends RigidBody3D
class_name CarScript

@export var debug : bool

@export_category("Engine")
@export var power_curve : Curve
@export var torque : float
@export var max_hp : float = 200
@export var drag : float = 10

@export_category("Car Specs")
@export var wheel_base : float
@export var turn_radius : float
@export var rear_track : float

@export_category("Wheels RPM")
@export var RRWheel : WheelScript
@export var RLWheel : WheelScript
var wheels_rpm : float
var rpm : float

@export_category("Gears")
@export var gear_ratio : Array[float]
@export var differential_ratio : float

@export var current_gear : float = 4

@onready var steer_component = $SteerComponent as SteerComponent

var rear_gear : bool
var speedmps : float
var speedkmh : float
var accel_input : float

func _process(delta):
	car_reverse_checker()
	speed_checker()
	input_checker()
	wheel_rpm_checker()
	
func wheel_rpm_checker():
	var speedmpm = speedmps * 60
	var wheel_dia = PI * (RRWheel.wheel_radius * 2)
	wheels_rpm = speedmpm / wheel_dia
	var w_rpm = ((wheels_rpm) * gear_ratio[current_gear])
	var curve_w_rpm = remap(w_rpm, 0, 1500, 0, 1)
	var rpm = power_curve.sample_baked(curve_w_rpm)
	torque = 15000 * (rpm) 
	print(rpm)

func input_checker():
	accel_input = Input.get_axis("reverse", "accelerate")
	steer_component.steering_input = -Input.get_axis("left", "right")

func car_reverse_checker():
	if linear_velocity.dot(basis.z) > 1:
		rear_gear = true
	elif Input.is_action_pressed("reverse"):
		rear_gear = true
	else:
		rear_gear = false

func speed_checker():
	speedmps = linear_velocity.length()
	speedkmh = int(speedmps * 3.6)
