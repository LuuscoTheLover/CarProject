extends RigidBody3D
class_name CarScript

@export var debug : bool

@export_category("Engine")
@export var engine_power : float
@export var drag : float = 10

@export_category("Car Specs")
@export var wheel_base : float
@export var turn_radius : float
@export var rear_track : float

@onready var steer_component = $SteerComponent as SteerComponent

var speedmph
var speedkmh

var accel_input : float

func _process(delta):
	accel_input = Input.get_axis("reverse", "accelerate")
	steer_component.steering_input = -Input.get_axis("left", "right")
	
	speedmph = linear_velocity.length()
	speedkmh = int(speedmph * 3.6)
