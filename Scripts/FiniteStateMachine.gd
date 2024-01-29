class_name FiniteStateMachine
extends Node

var current_state : State
var states : Dictionary = {}
@export var initial_state : State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_trasition.connect(change_state)
			child.force_state.connect(force_state)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.state_process(delta)
		
func _physics_process(delta):
	if current_state:
		current_state.state_physics_process(delta)

func change_state(changing_state : State, new_state_name : String):
	if changing_state != current_state:
		print("changing_state is: %s, and current state is: %s, and new_state is: %s" % [changing_state.name, current_state.name, new_state_name])
		return
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		push_error("new state is empty")
		return
	current_state.exit()
	new_state.enter()
	current_state = new_state

func force_state(old_state : State, new_state_name : String):
	var new_state = states.get(new_state_name.to_lower())
	current_state.exit()
	new_state.enter()
	current_state = new_state
