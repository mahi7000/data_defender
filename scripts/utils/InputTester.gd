extends Node

func _process(delta):
	# Test movement inputs
	if Input.is_action_pressed("move_left"):
		print("Moving LEFT")
	if Input.is_action_pressed("move_right"):
		print("Moving RIGHT") 
	if Input.is_action_pressed("move_up"):
		print("Moving UP")
	if Input.is_action_pressed("move_down"):
		print("Moving DOWN")
		
	# Test action inputs
	if Input.is_action_just_pressed("shoot"):
		print("SHOOTING!")
	if Input.is_action_just_pressed("firewall_burst"):
		print("FIREWALL BURST!")
