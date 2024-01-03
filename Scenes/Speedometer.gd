extends Label3D

@onready var car = $".."

var speed


func _ready():
	pass

func _process(delta):
	display_info()


func display_info():
	var z = car.global_basis.z
	speed = z.dot(car.linear_velocity)
	var speedkmh = abs(int(speed * 3.6))
	text = "%s KM/H" % [speedkmh]
