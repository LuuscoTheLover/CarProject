extends RigidBody3D
class_name CarScript

@export var debug : bool

@export_category("Engine")
@export var power_curve : Curve
@export var hp_torque_curve : Curve
@export var max_hp : float = 200
@export var torque : float
@export var idle_rpm : float
@export var redline : float
@export var drag : float = 10

var rpm : float

@export_category("Car Specs")
@export var wheel_base : float
@export var turn_radius : float
@export var rear_track : float

@export_category("Wheels RPM")
@export var RRWheel : WheelScript
@export var RLWheel : WheelScript
var wheels_rpm : float

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
	wheel_rpm_checker(delta)
	
func wheel_rpm_checker(delta):
	var speedmpm = speedmps * 60
	var wheel_dia = 2* PI * (RRWheel.wheel_radius)
	var w_rpm = speedmpm / wheel_dia

func input_checker():
	accel_input = Input.get_axis("reverse", "accelerate")
	steer_component.steering_input = -Input.get_axis("left", "right")

func speed_checker():
	speedmps = linear_velocity.length()
	speedkmh = int(speedmps * 3.6)
