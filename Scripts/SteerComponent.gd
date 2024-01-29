extends Node3D
class_name SteerComponent

@export_category("Car")
@export var car : CarScript

@export_category("AcrkermanAngles")
@export var Fr_wheel : WheelScript
@export var Fl_wheel : WheelScript

var ackerman_left : float
var ackerman_right : float

func _process(delta):
	if car.steering_input > 0:
		ackerman_right = rad_to_deg(atan(car.wheel_base / (car.turn_radius + (car.rear_track / 2))) * car.steering_input)
		ackerman_left = rad_to_deg(atan(car.wheel_base / (car.turn_radius - (car.rear_track / 2))) * car.steering_input)
	elif car.steering_input < 0:
		ackerman_right = rad_to_deg(atan(car.wheel_base / (car.turn_radius - (car.rear_track / 2))) * car.steering_input)
		ackerman_left = rad_to_deg(atan(car.wheel_base / (car.turn_radius + (car.rear_track / 2))) * car.steering_input)
	else:
		ackerman_left = 0
		ackerman_right = 0
	Fr_wheel.steer_angles = ackerman_right
	Fl_wheel.steer_angles = ackerman_left
