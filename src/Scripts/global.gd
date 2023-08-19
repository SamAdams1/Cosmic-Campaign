extends Node

var node_creation_parent = null
var reloadScene = false

#autoAim
var closeEnemies = []
var nearestEnemy = null

#score
var enemiesKilled = 0 
var finishLevel = 0
var coinsCollected = 0
var finishTime = '10:00'

# upgradable stats
var fireRate = 1
var bulletSpeed = 600
var bulletHealth = 1
var bulletDamageMultiplier = 0
var knockback = 0
var knockbackUnlocked = false

var playerMovementSpeed = 300
var playerHealth = 1000000
var boostCapacity = 2
var boostValue = 100



#skills
#var unlockedSkills = ['first', ]
var unlockedSkills = ['first',  'turret', 'bigBullet', 'bigBullet2Barrel']
#var unlockedSkills = ['first',  'turret', 'barrel2', 'barrel3', 'barrel4']
#var unlockedSkills = ['first',  'turret', '2direction', '3direction', '4direction']

var selectedButton = null
#var skillUnlockPoints = 0

#store
var store = null

#enemies
var enemyHealthAdded = 0
var timer = 1
var numOfEnemies = 0
var bossTime = false
var playerWon = false




func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
