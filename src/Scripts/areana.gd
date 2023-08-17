extends Node2D

onready var xpGem = preload("res://Scenes/Objects/experienceGem.tscn")
onready var player = get_tree().current_scene.get_node('Player')
onready var lootBase = get_tree().current_scene.get_node('lootBase')

onready var storeTimer = $storeSpawnTimer

func _ready():
	dropStartingXP()
	storeTimer.start()

func dropStartingXP():
	var xp = xpGem.instance()
	xp.global_position = player.global_position
	lootBase.call_deferred("add_child", xp)

func _on_storeSpawnTimer_timeout():
	pass # Replace with function body.

func spawnStore():
	
