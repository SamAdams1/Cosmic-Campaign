extends Node2D

onready var xpGem = preload("res://Scenes/Objects/experienceGem.tscn")
onready var store = preload("res://Scenes/loot_drops/Store.tscn")
onready var player = get_tree().current_scene.get_node('Player')
onready var lootBase = get_tree().current_scene.get_node('lootBase')

onready var storeTimer = $storeSpawnTimer
var storeMultiply = [2,3,-2,-3]

func _ready():
	if Global.reloadScene == true:
		Global.reloadScene = false
		get_tree().reload_current_scene()
	dropStartingXP()
	storeTimer.start()

func dropStartingXP():
	var xp = xpGem.instance()
	xp.experience = 1
	xp.global_position = player.global_position
	lootBase.call_deferred("add_child", xp)




func _on_storeSpawnTimer_timeout():
	if Global.store == null and !Global.bossTime:
		storeTimer.stop()
		var randPoint = storeMultiply[randi() % storeMultiply.size()]
#		print(randPoint, '  |  ', storeMultiply)
		var storeInstance = store.instance()
		storeInstance.global_position = player.global_position * randPoint
		add_child(storeInstance)
#		print(player.global_position)

func reloadScene():
	get_tree().reload_current_scene()
