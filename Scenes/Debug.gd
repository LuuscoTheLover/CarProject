extends CheckBox

@onready var car = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	button_pressed = car.debug
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	car.debug = button_pressed
