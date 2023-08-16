extends "res://Scripts/EnemyScripts/enemy_core.gd"

export (Array, PackedScene) var enemies

onready var retreatTimer = $retreatArea/retreatTimer
var itsSpawningTime = false
onready var enemySpawnPoint1 = $spawnPoint1
onready var enemySpawnPoint2 = $spawnPoint2
onready var enemySpawnTimer = $enemySpawnTimer

onready var enemyHolder = get_tree().current_scene.get_node('enemyHolder')
const bulletScene = preload("res://Scenes/Enemies/enemyBullet.tscn")
onready var shootTimer = $shootTimer
onready var rotater = $rotater

const radius = 200
const rotateSpeed = 3
const fireRate = 0.5
const numSpawnPoints = 10

#const radius = 200
#const rotateSpeed = 3
#const fireRate = 0.5
#const numSpawnPoints = 10

func _ready():
	movementSpeed = Global.playerMovementSpeed / 2
	
	player.camera.offset.y = -400
	
	var step = 2 * PI / numSpawnPoints
	
	for num in range(numSpawnPoints):
		var spawnPoint = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * num)
		spawnPoint.position = pos
		spawnPoint.rotation = pos.angle()
		rotater.add_child(spawnPoint)
	
	shootTimer.wait_time = fireRate
#	shootTimer.start()
	enemySpawnTimer.start()
	
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
#	self.global_position.y = player.global_position.y  - 700


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





























