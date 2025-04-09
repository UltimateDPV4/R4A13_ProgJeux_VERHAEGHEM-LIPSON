extends Node2D
 
var current_state: State
var previous_state: State

func _on_boss_pirate_start_boss_fight() -> void:
	current_state = get_child(0) as State
	previous_state = current_state
	current_state.enter()

func _on_lucius_kane_start_boss_fight() -> void:
	current_state = get_child(0) as State
	previous_state = current_state
	current_state.enter()
 
func change_state(state):
	current_state = find_child(state) as State
	
	previous_state.exit()
	current_state.enter()
	
	previous_state = current_state
