extends Node3D
class_name SteerComponent

@export_category("Car")
@export var car : CarScript

@export_category("AcrkermanAngles")
@export var Fr_wheel : WheelScript
@export var Fl_wheel : WheelScript

var ackerman_left : float
var ackerman_right : float
var steering_input : float

func _process(delta):
	#print(ackerman_left, ackerman_right)
	if steering_input > 0:
		#ackerman_right = steering_input * 40
		ackerman_right = rad_to_deg(atan(car.wheel_base / (car.turn_radius + (car.rear_track / 2))) * steering_input)
		ackerman_left = rad_to_deg(atan(car.wheel_base / (car.turn_radius - (car.rear_track / 2))) * steering_input)
	elif steering_input < 0:
		#ackerman_right = steering_input * -40
		ackerman_right = rad_to_deg(atan(car.wheel_base / (car.turn_radius - (car.rear_track / 2))) * steering_input)
		ackerman_left = rad_to_deg(atan(car.wheel_base / (car.turn_radius + (car.rear_track / 2))) * steering_input)
	else:
		ackerman_left = 0
		ackerman_right = 0
	Fr_wheel.steer_angles = ackerman_right
	Fl_wheel.steer_angles = ackerman_left
