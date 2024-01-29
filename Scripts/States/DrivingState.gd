extends State
class_name DrivingState

var driving_input : float

func enter():
	pass


func exit():
	pass
	

func state_process(delta):
	driving_input = car.accel_input - car.brake_input
	
	if not car.grounded:
		state_trasition.emit(self, "IdleState")
	
	if car.zmotion > -1 and not Input.is_action_pressed("accelerate"):
		state_trasition.emit(self, "IdleState")
	
	if Input.is_action_pressed("reverse"):
		state_trasition.emit(self, "BrakingState")


func state_physics_process(delta):
	acceleration()
	
	

func acceleration():
	for wheel : WheelScript in car.wheels:
		if wheel.traction and wheel.is_colliding():
			var accel_dir = -wheel.global_basis.z
			var car_speed = accel_dir.dot(car.linear_velocity)
			var normalized_speed = clampi(abs(car_speed / car.max_speed), 0, 1)
			var avaliable_torque = car.acceleration_curve.sample_baked(normalized_speed) * driving_input
			car.apply_force(accel_dir * avaliable_torque, wheel.force_point - car.global_position)
			if car.debug:
				DebugDraw3D.draw_arrow_line(wheel.force_point, wheel.force_point - (accel_dir * ((avaliable_torque / 1000) / 10)), Color.BLUE, 0.1, true)
