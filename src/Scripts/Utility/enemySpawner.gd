extends Node2D

export (Array, PackedScene) var enemies
# [alien1, alien2, alien3, alien4]


onready var indexes = [0]
 

onready var enemyHolder = get_tree().current_scene.get_node('enemyHolder')
onready var spawnPosition = $Path2D/PathFollow2D/Position2D
onready var spawnPath = $Path2D/PathFollow2D
onready var spawnTimer = $spawnTimer


onready var timer = Global.timer

var difficultyChanges = {
	510: {
		'enemyHealth': 4,
		'spawnTime': 1,
		'indexes': [0, 1],
	},
	420: {
		'enemyHealth': 3,
		'spawnTime': .5,
		'indexes': [1, 2],
	},
	330: {
		'enemyHealth': 6,
		'spawnTime': .7,
		'indexes': [2,3],
	},
	240: {
		'enemyHealth': 9,
		'spawnTime': .5,
		'indexes': [3,4],
	},
	150: {
		'enemyHealth': 12,
		'spawnTime': .5,
		'indexes': [4,5],
	},
	75: {
		'enemyHealth': 15,
		'spawnTime': .2,
		'indexes': [1,2,3,4,5],
	},
}
#[510, 420, 330, 240, 150, 75]

var time = timer

func _physics_process(delta):
	timer -= delta
	time = int(timer)
	
	if difficultyChanges.has(time):
		changeDifficulty()

func _on_spawnTimer_timeout():
	spawnEnemy()
#	print(int(timer))

func spawnEnemy():
	for enemy in enemySpawnList():
		var enemyInstance = enemy.instance()
		enemyInstance.global_position = getRandomPosition()
		enemyHolder.add_child(enemyInstance)
		
func enemySpawnList():
	var enemyList = []
	for num in indexes:
#		print(num)
		enemyList.append(enemies[num])
#	print(enemyList)
	return enemyList


func changeDifficulty():
	Global.enemyHealthAdded = difficultyChanges[time]['enemyHealth']
	spawnTimer.wait_time = difficultyChanges[time]['spawnTime']
	indexes = difficultyChanges[time]['indexes']
#	print(Global.enemyHealthAdded, '  |  ', spawnTimer.wait_time, '  |  ', indexes)



func getRandomPosition():
#	var rng = RandomNumberGenerator.new().randomize()
	spawnPath.offset = rand_range(0, 5000)
	return spawnPosition.global_position
