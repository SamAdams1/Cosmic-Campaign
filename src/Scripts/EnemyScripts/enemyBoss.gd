extends "res://Scripts/EnemyScripts/enemy_core.gd"

export (Array, PackedScene) var enemies

onready var retreatTimer = $retreatArea/retreatTimer

onready var enemySpawnPoint1 = $spawnPoint1
onready var enemySpawnPoint2 = $spawnPoint2
onready var enemySpawnTimer = $enemySpawnTimer
var itsSpawningTime = false

onready var enemyHolder = get_tree().current_scene.get_node('enemyHolder')
const bulletScene = preload("res://Scenes/Enemies/enemyBullet.tscn")
onready var shootTimer = $shootTimer
onready var rotater = $rotater

onready var origHealth = health

var radius = 200
var rotateSpeed = 2.4
var fireRate = 0.4
var numSpawnPoints = 5

#var radius = 200
#var rotateSpeed = 3
#var fireRate = 0.5
#var numSpawnPoints = 10

func _ready():
#	health *= Global.bulletDamageMultiplier
	Global.enemyHealthAdded = 20
	
	Global.bossTime = true
	movementSpeed = Global.playerMovementSpeed / 2
	shootTimer.wait_time = fireRate
	
	var step = 2 * PI / numSpawnPoints
	for num in range(numSpawnPoints):
		var spawnPoint = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * num)
		spawnPoint.position = pos
		spawnPoint.rotation = pos.angle()
		rotater.add_child(spawnPoint)
	
	player.bossHealthBar.visible = true
	player.bossHealthBar.max_value = health
	player.bossHealthBar.value = health

func _on_shootTimer_timeout():
	for point in rotater.get_children():
		var bullet = bulletScene.instance()
		get_tree().root.add_child(bullet)
		bullet.position = point.global_position
		bullet.rotation = point.global_rotation


func _process(delta):
	basic_movement_towards_player(delta)
	
	var newRotation = rotater.rotation_degrees + rotateSpeed
	rotater.rotation_degrees = fmod(newRotation, 360)
	
	if player.camera.offset.y > -500:
		 player.camera.offset.y -=  10
	if player.camera.zoom < Vector2(2.5,2.5):
		player.camera.zoom += Vector2(delta,delta)
	self.global_position.y = player.global_position.y -900
	
	checkHealth()

func spawnEnemy():
	var enemyNumber = randEnemy()
	var enemy1 = enemies[enemyNumber]
	var enemy2 = enemies[enemyNumber]
	var enemyInstance = enemy1.instance()
	enemyInstance.global_position = enemySpawnPoint1.global_position
	enemyHolder.add_child(enemyInstance)
	
	enemyInstance = enemy2.instance()
	enemyInstance.global_position = enemySpawnPoint2.global_position
	enemyHolder.add_child(enemyInstance)

func randEnemy():
	return rand_range(0, enemies.size())

func _on_enemySpawnTimer_timeout():
	spawnEnemy()


func _on_retreatArea_body_entered(body):
	if body.is_in_group('player'):
		retreatTimer.stop()
		movementSpeed = Global.playerMovementSpeed
		playerPush = -1

func _on_retreatArea_body_exited(body):
	if body.is_in_group('player'):
		movementSpeed = 0
		retreatTimer.start()

func _on_retreatTimer_timeout():
	movementSpeed = Global.playerMovementSpeed / 2
	playerPush = 1



var bossWasSpawning = false
func _on_keepPlayerClose_body_exited(body):
	if body.is_in_group('player'):
		playerPush = 1
		movementSpeed = Global.playerMovementSpeed * 2


func _on_keepPlayerClose_body_entered(body):
	if body.is_in_group('player'):
		movementSpeed = Global.playerMovementSpeed

func checkHealth():
	if health > origHealth * .75:
		if shootTimer.is_stopped():
			shootTimer.start()
	
	elif health > origHealth * .50:
		if enemySpawnTimer.is_stopped():
			shootTimer.stop()
			enemySpawnTimer.start()
	
	elif health > origHealth * .25:
		if shootTimer.is_stopped():
			enemySpawnTimer.stop()
			shootTimer.start()
			rotateSpeed = 3
			fireRate = 0.5
			numSpawnPoints = 10
			shootTimer.wait_time = fireRate
	
	elif health > 0:
		if enemySpawnTimer.is_stopped():
			shootTimer.stop()
			enemySpawnTimer.start()
	
	else:
		shootTimer.stop()
		enemySpawnTimer.stop()



























