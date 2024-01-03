extends RigidBody3D
class_name Car

@export_category("Car Specs")
@export var wheel_base : float = 2.55
@export var turn_radius : float = 10.8
@export var rear_track : float = 1.525



@onready var display = $Display
@onready var car = $"."

var speed : float

func _physics_process(delta):
	display_info()

func display_info():
	var z = car.global_basis.z
	speed = z.dot(car.linear_velocity)
	var speedkmh = int(speed * 3.6)
	display.text = "%s KM/H" % [speedkmh]
