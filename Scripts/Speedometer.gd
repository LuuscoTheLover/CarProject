extends Label3D

@onready var car = $".."


func _ready():
	pass



func _process(delta):
	
	text = "%s KM/H" % str(car.speedkmh)
