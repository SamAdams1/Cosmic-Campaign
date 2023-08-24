extends Node2D

onready var xpGem = preload("res://Scenes/Objects/experienceGem.tscn")
onready var store = preload("res://Scenes/loot_drops/Store.tscn")
onready var player = get_tree().current_scene.get_node('Player')
onready var lootBase = get_tree().current_scene.get_node('lootBase')

onready var storeTimer = $storeSpawnTimer
var storeMultiply = [2,3,-2,-3]

onready var music = $music

func _ready():
	music.play()
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

onready var song1 = preload("res://Audio/Music/let-the-games-begin-21858.wav")
onready var song2 = preload("res://Audio/Music/cyber-war-126419.mp3")
onready var song3 = preload("res://Audio/Music/music-alexandr-zhelanov.wav")
onready var song4 = preload("res://Audio/Music/cosmic-glow-6703.mp3")
onready var song5 = preload("res://Audio/Music/broken-Defekt_Maschine.wav")

var songNumber = 1
func _on_music_finished():
	songNumber += 1
	if songNumber >= 6:
		songNumber = 0
		
	match songNumber:
		1:
			music.stream = song1
		2:
			music.stream = song2
		3:
			music.stream = song3
		4:
			music.stream = song4
		5:
			music.stream = song5
	
	yield(get_tree().create_timer(5), "timeout")
	music.play()









