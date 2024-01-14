extends Camera3D


@onready var car = $"../.."
@onready var pivot = $".."

var look : Vector3
func _ready():
	look = car.global_position

func _process(delta):
	if current:
		pivot.global_position = lerp(pivot.global_position, car.global_position, delta * 20.0)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, car.rotation.y, delta * $"../Camera".direction_offset)
		look = lerp(look, car.global_position + car.linear_velocity, delta * 20)
		look_at(look)
		rotation_degrees.x = clamp(rotation_degrees.x, -8, -10)
		rotation_degrees.y = clamp(rotation_degrees.x, 180, 270)
