extends Node2D



export var mainGameScene : PackedScene
export var mainMenu : PackedScene
onready var music = $music
onready var scoreLabel = $MarginContainer/VBoxContainer/score
onready var gameOverLabel = $MarginContainer/VBoxContainer/gameOver
onready var background = $ColorRect

onready var newGameButton = $MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/NewGameButton


func _ready():
	if Global.playerWon:
		gameOverLabel.text = 'YOU WON!'
		background.color = Color(0.023529, 0.439216, 0.164706)
		newGameButton.get('custom_styles/normal/bg_color').bg_color = Color(0.054902, 0.278431, 0.031373)
		newGameButton.get('custom_styles/pressed/bg_color').bg_color = Color(0.043137, 0.172549, 0.058824)
		newGameButton.get('custom_styles/hover/bg_color').bg_color = Color(0.003922, 0.282353, 0.015686)
		
	get_tree().paused = false
	music.play()
	Global.unlockedSkills = ['first', ]
	Global.selectedButton = null
	scoreLabel.text = 'Level: '+str(Global.finishLevel)+'\nAliens Killed: '+str(Global.enemiesKilled)+'\nCoins Collected: '+str(Global.coinsCollected) + '\nTime:'+Global.finishTime

func _on_NewGameButton_pressed():
	Global.reloadScene = true
	get_tree().change_scene(mainGameScene.resource_path)


func _on_mainMenuButton_pressed():
	get_tree().change_scene(mainMenu.resource_path)


func _on_quitButton_pressed():
	 get_tree().quit()
