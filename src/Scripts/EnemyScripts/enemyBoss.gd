extends "res://Scripts/EnemyScripts/enemy_core.gd"

export (Array, PackedScene) var enemies

var cameraZoom = 3

onready var retreatTimer = $retreatArea/retreatTimer

onready var enemySpawnPoint1 = $spawnPoint1
onready var enemySpawnPoint2 = $spawnPoint2
onready var enemySpawnTimer = $enemySpawnTimer
var itsSpawningTime = false
var stopMoving = false

onready var enemyHolder = get_tree().current_scene.get_node('enemyHolder')
const bulletScene = preload("res://Scenes/Enemies/enemyBullet.tscn")
onready var shootTimer = $shootTimer
onready var rotater = $rotater

onready var origHealth = health

var radius = 200
var rotateSpeed = 2.4
var fireRate = 0.3
var numSpawnPoints = 5

#var radius = 200
#var rotateSpeed = 3
#var fireRate = 0.5
#var numSpawnPoints = 10

func _ready():
	killNearbyEnemies()
	Global.enemyHealthAdded = 25
	
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
#	self.global_position.y = player.global_position.y -900
	if !stopMoving:
		basic_movement_towards_player(delta)
	
		var newRotation = rotater.rotation_degrees + rotateSpeed
		rotater.rotation_degrees = fmod(newRotation, 360)
		
#	if player.camera.offset.y > -500:
#		 player.camera.offset.y -=  10
	if player.camera.zoom < Vector2(cameraZoom, cameraZoom):
		player.camera.zoom += Vector2(delta,delta)
	
	checkHealth()
	if isBossDead:
		bossDead()
		isBossDead = false
		
func spawnEnemy():
	var enemyNumber1 = randEnemy()
	var enemyNumber2 = randEnemy()
	var enemy1 = enemies[enemyNumber1]
	var enemy2 = enemies[enemyNumber2]
	var enemyInstance = enemy1.instance()
	enemyInstance.speed += 25
	enemyInstance.global_position = enemySpawnPoint1.global_position
	enemyHolder.add_child(enemyInstance)
	
	enemyInstance = enemy2.instance()
	enemyInstance.speed += 25
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
			killNearbyEnemies()
			enemySpawnTimer.stop()
			shootTimer.start()
			rotateSpeed = 3.3
			fireRate = 0.2
			numSpawnPoints = 10
			shootTimer.wait_time = fireRate
	
	elif health > 0:
		if enemySpawnTimer.is_stopped():
			shootTimer.stop()
			enemySpawnTimer.start()
	
	else:
		shootTimer.stop()
		enemySpawnTimer.stop()
		killNearbyEnemies()

func bossDead():
	retreatTimer.stop()
	stopMoving = true
	movementSpeed = 0
	
	$Sprite.visible = false
	player.toggleFire = false
	player.turret.toggleFire = false
	player.bossDead = true
	
	cameraZoom = 4
	spawnWinXP()

func spawnWinXP():
	var xpAmount = 0
	var loop = 0
	while loop <= 150:
		xpAmount += 1
		
		spawnXP(-6, xpAmount, 15)
		spawnCoin(-10, xpAmount)
		spawnXP(-15, xpAmount, 1)
		
		loop += 1
		if xpAmount >= 2:
			xpAmount = 0
		yield(get_tree().create_timer(0.1), "timeout")
		
	winScreen()

func spawnXP(xpSpeed, xpAmount, mult):
	var newXPGem = xpGem.instance()
	newXPGem.experience = xpAmount * mult
	newXPGem.speed = xpSpeed
	newXPGem.global_position = global_position
	lootBase.call_deferred("add_child", newXPGem)
	
func spawnCoin(coinSpeed, coinAmount):
	var newCoin = coin.instance()
	newCoin.coinValue = coinAmount * 2
	newCoin.speed = coinSpeed
	newCoin.global_position = global_position
	lootBase.call_deferred("add_child", newCoin)

func addDeathExplosion():
	var explosion_instance = explosion.instance()
	explosion_instance.position = get_global_position()
	explosion_instance.scale = Vector2(15,15)
	explosion_instance.speed_scale = 1.5
	get_tree().get_root().add_child(explosion_instance)

func winScreen():
	player.bossHealthBar.visible = false
	self.visible = false
	addDeathExplosion()
	
	Global.playerWon = true
	yield(get_tree().create_timer(4), "timeout")
	player._on_deathSound_finished()
	
func killNearbyEnemies():
	for enemy in enemyHolder.get_children():
		if enemy != self:
			enemy._on_HurtBox_hurt(enemy.health)



















