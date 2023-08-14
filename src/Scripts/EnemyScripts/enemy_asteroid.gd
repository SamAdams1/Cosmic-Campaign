extends "res://Scripts/EnemyScripts/enemy_core.gd"

var stun = false
var pushValue = movementSpeed / 2
onready var inFront = $inFront

func _process(delta):
	if stun == false:
		basic_movement_towards_player(delta)
		inFront.look_at(player.global_position)
	
#	elif stun:
#		var direction = global_position.direction_to(player.global_position)
#		velocity = -(direction * movementSpeed)
#		move_and_slide(velocity)


func _on_AudioStreamPlayer_finished():
	queue_free()
	

func _on_stun_timer_timeout():
	stun = false
	
func _on_HurtBox_area_entered(area):
	if area.is_in_group("attack") and knockbackUnlocked:
		velocity = -velocity * knockback
		stun = true
		$stun_timer.start()

var enemyPushList = []

func _on_enemyPush_area_entered(area):
	if area.is_in_group('enemyPush') and movementSpeed > area.get_parent().get_parent().movementSpeed:
		area.get_parent().get_parent().movementSpeed += pushValue
		enemyPushList.append(area)
#		print('speed', ' | ', enemyPushList)


func _on_enemyPush_area_exited(area):
	if area.is_in_group('enemyPush') and enemyPushList.has(area):
		area.get_parent().get_parent().movementSpeed -= pushValue
#		print('leave', ' | ')
