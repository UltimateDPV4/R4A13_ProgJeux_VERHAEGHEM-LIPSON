extends State

func enter():
	print("Enter Deplacement")
	owner.set_physics_process(true)
	get_tree().call_group('MalakarBoss', 'setAnimationBossFight', "deplacement")
 
func exit():
	print("Exit Deplacement")
	owner.set_physics_process(false)
 
