extends RigidBody2D

var speed = 200
onready var player = get_tree().current_scene.get_node('Player')

func _physics_process(delta):
	moveTowardsPlayer()
	
func moveTowardsPlayer():
	pass

#func look_follow(state, current_transform, target_position):
#	var up_dir = Vector3(0, 1, 0)
#	var cur_dir = current_transform.basis * Vector3(0, 0, 1)
#	var target_dir = (target_position - current_transform.origin).normalized()
#	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
#
#	state.angular_velocity = up_dir * (rotation_angle / state.step)
#
#func _integrate_forces(state):
#	var target_position = player.global_transform.origin
#	look_follow(state, global_transform, target_position)
