extends State
class_name HandBrakeState

func enter():
	pass


func exit():
	pass
	

func state_process(delta):
	if Input.is_action_just_released("handbrake"):
		state_trasition.emit(self, "IdleState")
		
	if car.zmotion in range(-3, 3):
		state_trasition.emit(self, "IdleState")
		

func state_physics_process(delta):
	if car.speedkmh < 3:
			car.linear_velocity = Vector3.ZERO
	braking()


func braking():
	for wheel : WheelScript in car.wheels:
		if wheel.is_colliding() and wheel.traction:
			car.apply_force(car.hand_brake_input * -sign(car.zmotion) * car.global_basis.z, wheel.force_point - car.global_position)
