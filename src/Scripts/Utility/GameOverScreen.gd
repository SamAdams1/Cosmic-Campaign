extends Node2D


export var mainGameScene : PackedScene
export var mainMenu : PackedScene
onready var music = $music
onready var scoreLabel = $MarginContainer/VBoxContainer/score

func _ready():
	get_tree().paused = false
	music.play()
	Global.unlockedSkills = ['first', ]
	Global.selectedButton = null
	scoreLabel.text = 'Level: '+str(Global.finishLevel)+'\nAliens Killed: '+str(Global.enemiesKilled)+'\nCoins Collected: '+str(Global.coinsCollected) + '\nTime:'+Global.finishTime

func _on_NewGameButton_pressed():
	get_tree().change_scene(mainGameScene.resource_path)


func _on_mainMenuButton_pressed():
	get_tree().change_scene(mainMenu.resource_path)


func _on_quitButton_pressed():
	 get_tree().quit()
