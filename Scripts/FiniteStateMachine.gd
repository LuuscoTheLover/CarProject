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
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.state_process(delta)
		
func _physics_process(delta):
	if current_state:
		current_state.state_physics_process(delta)

func change_state(old_state : State, new_state_name : String):
	if old_state != current_state:
		push_error("old state is: %s, and current state is: %s" % [old_state.name, current_state.name])
		return
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		push_error("new state is empty")
		return
	current_state.exit()
	new_state.enter()
	current_state = new_state
