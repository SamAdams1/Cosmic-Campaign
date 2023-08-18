extends Node2D

export (Array, PackedScene) var enemies
onready var bossEnemy = preload("res://Scenes/Enemies/bossEnemy.tscn")

onready var indexes = [0]
 

onready var enemyHolder = get_tree().current_scene.get_node('enemyHolder')
onready var spawnPosition = $Path2D/PathFollow2D/Position2D
onready var spawnPath = $Path2D/PathFollow2D
onready var spawnTimer = $spawnTimer

var bossSpawnedOnce = false

onready var timer = Global.timer

#[510, 420, 330, 240, 150, 75]
var difficultyChanges = {
	555: {
		'enemyHealth': 2,
		'spawnTime': .5,
		'indexes': [0,],
	},
	510: {
		'enemyHealth': 4,
		'spawnTime': .8,
		'indexes': [0, 1],
	},
	420: {
		'enemyHealth': 8,
		'spawnTime': .7,
		'indexes': [1, 2],
	},
	330: {
		'enemyHealth': 12,
		'spawnTime': .6,
		'indexes': [2,3],
	},
	240: {
		'enemyHealth': 20,
		'spawnTime': .6,
		'indexes': [3,4],
	},
	150: {
		'enemyHealth': 15,
		'spawnTime': .4,
		'indexes': [4,5],
	},
	75: {
		'enemyHealth': 5,
		'spawnTime': .4,
		'indexes': [1,2,3,4,5],
	},
}

var time = timer

func _ready():
	spawnTimer.wait_time = 1
	

func _physics_process(delta):
	timer -= delta
	time = int(timer)
	
	if difficultyChanges.has(time):
		changeDifficulty()
		
	if timer <= 0 and !bossSpawnedOnce:
		var totalEnemies = topEnemies + rightEnemies + bottomEnemies + leftEnemies
		spawnTimer.stop()
		if totalEnemies == 0:
			bossSpawnedOnce = true
			spawnBossEnemy()

func _on_spawnTimer_timeout():
	if !Global.bossTime:
		spawnEnemy()
		Global.numOfEnemies += 1
	#	print(Global.numOfEnemies)

func spawnEnemy():
	for enemy in enemySpawnList():
		var enemyInstance = enemy.instance()
		enemyInstance.global_position = getRandomPosition()
		enemyHolder.add_child(enemyInstance)
		
func enemySpawnList():
	var enemyList = []
	for num in indexes:
		enemyList.append(enemies[num])
	return enemyList


func changeDifficulty():
	Global.enemyHealthAdded = difficultyChanges[time]['enemyHealth']
	spawnTimer.wait_time = difficultyChanges[time]['spawnTime']
	indexes = difficultyChanges[time]['indexes']


func getRandomPosition():
	var spawnPoints = getSpawnPoints()
	spawnPath.offset = rand_range(spawnPoints[0], spawnPoints[1])
	return spawnPosition.global_position

#[topEnemies, rightEnemies, bottomEnemies, leftEnemies]
func getSpawnPoints():
	if topEnemies == 0 :
		return [-600,625]
	elif rightEnemies == 0:
		return [600, 1800]
	elif bottomEnemies == 0:
		return [1800,2800]
	elif leftEnemies == 0:
		return [2900, 4100]
	
	var areaList = [topEnemies, rightEnemies, bottomEnemies, leftEnemies]
	var smallestArea = areaList.min()
	var index = areaList.find(smallestArea)
	
	match index:
		0:#top
			return [-600,625]
		1:#right 
			return [600, 1800]
		2:#bottom
			return [1800,2800]
		3:#left
			return [2700, 4100]


func spawnBossEnemy():
	var bossInstance = bossEnemy.instance()
	spawnPath.offset = rand_range(600, 700)
	bossInstance.global_position = spawnPosition.global_position
	enemyHolder.add_child(bossInstance)


var leftEnemies = 0
var rightEnemies = 0
var topEnemies = 0
var bottomEnemies = 0

func _on_leftSpawn_body_entered(body):
	if body.is_in_group("enemy"):
		leftEnemies += 1
func _on_leftSpawn_body_exited(body):
	if body.is_in_group("enemy"):
		leftEnemies -= 1


func _on_rightSpawn_body_entered(body):
	if body.is_in_group("enemy"):
		rightEnemies += 1
func _on_rightSpawn_body_exited(body):
	if body.is_in_group("enemy"):
		rightEnemies -= 1


func _on_topSpawn_body_entered(body):
	if body.is_in_group("enemy"):
		topEnemies += 1
func _on_topSpawn_body_exited(body):
	if body.is_in_group("enemy"):
		topEnemies -= 1


func _on_bottomSpawn_body_entered(body):
	if body.is_in_group("enemy"):
		bottomEnemies += 1
func _on_bottomSpawn_body_exited(body):
	if body.is_in_group("enemy"):
		bottomEnemies -= 1
