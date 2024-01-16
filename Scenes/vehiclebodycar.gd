extends VehicleBody3D
var speedmps : float
var speedkmh : float
var accel_input : float
var rear_gear : bool


func _ready():
	steering = 20


func _process(delta):
	speed_checker()
	car_reverse_checker()

func speed_checker():
	speedmps = linear_velocity.length()
	speedkmh = int(speedmps * 3.6)

func car_reverse_checker():
	if linear_velocity.dot(basis.z) > 1:
		rear_gear = true
	elif Input.is_action_pressed("reverse"):
		rear_gear = true
	else:
		rear_gear = false
