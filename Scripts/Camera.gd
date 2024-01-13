extends Camera3D

@onready var car = $"../.."
@onready var pivot = $".."
@export var direction_offset : float = 1.0

var look : Vector3
func _ready():
	look = car.global_position

func _process(delta):
	pivot.global_position = lerp(pivot.global_position, car.global_position, delta * 20.0)
	pivot.rotation.y = lerp_angle(pivot.rotation.y, car.rotation.y, delta * 5.0)
	look = lerp(look, car.global_position + Vector3(car.linear_velocity.x * direction_offset, car.linear_velocity.y, car.linear_velocity.z) , delta * 5.0)
	look_at(look)
	rotation_degrees.x = clamp(rotation_degrees.x, -20, -30)
	if car.linear_velocity.dot(basis.z) > 0:
		pass
		#rearcam
	else:
		pass
		#frontcam
