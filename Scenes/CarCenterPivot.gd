extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@onready var car = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.lerp(car.global_position, delta * 20.0)
	global_transform = global_transform.interpolate_with(car.global_transform, delta * 5.0)
	
