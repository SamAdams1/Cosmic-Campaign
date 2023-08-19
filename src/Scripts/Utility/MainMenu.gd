extends Node2D


export var mainGameScene : PackedScene

onready var music = $MenuMusic
onready var credits = $Credits

func _ready():
	credits.visible = false
	music.play()

func _on_NewGameButton_pressed():
	get_tree().change_scene(mainGameScene.resource_path)


func _on_OptionsButton_pressed():
	pass


func _on_CreditsButton_pressed():
	credits.visible = true


func _on_backButton_pressed():
	credits.visible = false
