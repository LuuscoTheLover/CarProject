extends RigidBody3D
class_name CarScript

@export var debug : bool

@export_category("Engine")
@export var horse_power : float
@export var acceleration_curve : Curve = null
@export var brake_power : float

var zmotion : float

@export_category("Gears")
@export var max_speed_gear : Array[float]
@export var max_speed_reverse : float
@export var gear_ratio : Array[float]
@export var differential_ratio : float
@export var current_gear : float = 0

var max_speed : float

@export_category("Wheels")
@export var steer_curve : Curve = null
@export var traction_curve : Curve = null
@export var wheels : Array[WheelScript]

var steering_input : float
@onready var steer_component = $SteerComponent as SteerComponent

@export_category("Car Specs")
@export var wheel_base : float
@export var turn_radius : float
@export var rear_track : float
@export var drag : float = 10


var wheel_on_ground : int
var grounded : bool

var speedmps : float
var speedkmh : float

var current_state : String
@onready var fsm : FiniteStateMachine = $"Driving States"

var accel_input : float
var reverse_input : float
var brake_input : float

func _process(delta):
	wheel_on_ground = int($FRWheel.grounded) + int($FLWheel.grounded) + int($RRWheel.grounded) + int($RLWheel.grounded)
	grounded = false
	if wheel_on_ground >= 3:
		grounded = true
	zmotion = linear_velocity.dot(basis.z)
	max_speed = max_speed_gear[current_gear] / 3.6
	current_state = fsm.current_state.name
	speed_checker()
	input_checker()
	
	
func input_checker():
	brake_input = Input.get_action_strength("reverse") * ((mass / drag) + brake_power)
	accel_input = Input.get_action_strength("accelerate") * (horse_power * 100)
	reverse_input = Input.get_action_strength("reverse") * (horse_power * 100)
	steering_input = -Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("reset"):
		global_position.y += 7
		rotation_degrees = Vector3.ZERO
	
func wheel_rpm():
	var wheels_rpm = (( speedmps * 60) / (2 * PI * ($RRWheel.wheel_radius))) * differential_ratio * gear_ratio[current_gear]
	return wheels_rpm
	
func speed_checker():
	speedmps = linear_velocity.length()
	speedkmh = int(speedmps * 3.6)
