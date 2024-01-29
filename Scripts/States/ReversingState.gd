extends State
class_name ReversingState

var driving_input : float
func enter():
	pass


func exit():
	pass
	

func state_process(delta):
	driving_input = car.accel_input - car.reverse_input
	
	if not car.grounded:
		state_trasition.emit(self, "IdleState")
		
	if car.zmotion < 1 and not Input.is_action_pressed("reverse"):
			state_trasition.emit(self, "IdleState")
			
	if Input.is_action_pressed("accelerate"):
			state_trasition.emit(self, "DrivingState")

func state_physics_process(delta):
	reversing()


func reversing():
	for wheel : WheelScript in car.wheels:
		if wheel.traction and wheel.is_colliding():
			var dir = -wheel.global_basis.z
			var normalized_speed = clampi(abs(-car.zmotion / (car.max_speed_reverse / 3.6)), 0, 1)
			var avaliable_torque = car.acceleration_curve.sample_baked(normalized_speed) * driving_input
			car.apply_force(dir * avaliable_torque, wheel.force_point - car.global_position)
			if car.debug:
				DebugDraw3D.draw_arrow_line(wheel.force_point, wheel.force_point - (dir * ((avaliable_torque / 1000) / 10)), Color.BLUE, 0.1, true)
