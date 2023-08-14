extends "res://Scripts/EnemyScripts/enemy_core.gd"

var stun = false
var pushValue = movementSpeed / 2
onready var inFront = $inFront
onready var pushArea = $inFront/enemyPush
var lookDirection = Vector2.ZERO
var isPlayerPushing = false

func _process(delta):
	lookDirection = player.global_position 
	if stun == false:
		basic_movement_towards_player(delta)
		inFront.look_at(lookDirection)
	if isPlayerPushing:
		playerPush = -1
#		pushArea.rotation_degrees = 180
	else:
		playerPush = 1
#		pushArea.rotation_degrees = 0
#	elif stun:
#		var direction = global_position.direction_to(player.global_position)
#		velocity = -(direction * movementSpeed)
#		move_and_slide(velocity)


func _on_AudioStreamPlayer_finished():
	print(lookDirection)
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
	if enemyPushList.has(area):
		area.get_parent().get_parent().movementSpeed -= pushValue
		enemyPushList.erase(area)
#		print('leave', ' | ')
