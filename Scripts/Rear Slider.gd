extends HSlider


@onready var car = $"../../../"
# Called when the node enters the scene tree for the first time.
func _ready():
	value = car.traction_grip

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	car.traction_grip = value
