extends Label3D

@onready var car = $".."


func _ready():
	pass



func _process(delta):
	text = "%s KM/H \n %s Gear \n %s" % [str(car.speedkmh), car.current_gear + 1, car.current_state]
