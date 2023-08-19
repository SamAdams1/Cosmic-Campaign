extends RigidBody2D

var explosion = preload("res://Scenes/Explosion.tscn")
onready var sound = $bulletHitSound
onready var regBulletHit = preload("res://Audio/SFX/hit.wav")
onready var explosiveBulletHit = preload("res://Audio/SFX/short-explosion.wav")
onready var sprite = $Sprite
onready var hitBoxCollisionShape = $HitBox/CollisionShape2D
onready var hitBoxDisableTimer = $HitBox/DisableHitBoxTimer
onready var hitBox = $HitBox
onready var collision = $CollisionShape2D

#onready var statUpgrade = preload("res://Scenes/Menus/StatUpgrade.tscn")
onready var player = get_tree().current_scene.get_node('Player')

var bulletHealth = Global.bulletHealth
onready var bulletDamageMultiplier = Global.bulletDamageMultiplier


var target = null
var direction = Vector2.RIGHT
onready var speed = Global.bulletSpeed / 2
onready var homingBulletUnlocked = player.homingBulletUnlocked
onready var explosiveBulletUnlocked = player.explosiveBulletUnlocked

func _ready():
	hitBox.damage += bulletDamageMultiplier
	if self.is_in_group('bigBullet'):
		hitBox.damage *= 2
	
#	sound.volume_db = -20
	if homingBulletUnlocked:
		hitBoxDisableTimer.wait_time = 10
	elif Global.bulletSpeed <= 700:
		hitBoxDisableTimer.wait_time = 0.3
	elif Global.bulletSpeed == 900:
		hitBoxDisableTimer.wait_time = 0.2
	elif Global.bulletSpeed <= 1100:
		hitBoxDisableTimer.wait_time = 0.15
	else:
		hitBoxDisableTimer.wait_time = 0.1
	
	if homingBulletUnlocked:
		bulletHealth = 0
	if bulletHealth == 0:
		self.set_collision_mask_bit(2, true)

func _physics_process(delta):
	if target and is_instance_valid(target) and homingBulletUnlocked:
		translate(direction * speed * delta)
		direction = target.global_position - global_position
		direction = direction.normalized()
		look_at(target.global_position)
#	if target and !is_instance_valid(target):
#		queue_free()
#	if self.visible == false:
#		hitBox.call_deferred("set", "disabled", true)
#		hitBoxCollisionShape.call_deferred("set", "disabled", true)

func _on_bigBullet_body_entered(body):
	if body.is_in_group("enemy"):
		sprite.visible = false
		if explosiveBulletUnlocked:
			hitBoxCollisionShape.scale = Vector2(5,5)
			var explosion_instance = explosion.instance()
			explosion_instance.scale = Vector2(2,2)
			explosion_instance.position = get_global_position()
			get_tree().get_root().add_child(explosion_instance)
			sound.stream = explosiveBulletHit
			if sound.is_stopped():
				sound.play()
			
			yield(get_tree().create_timer(0.1), "timeout")
			hitBoxCollisionShape.call_deferred("set", "disabled", true)
			collision.call_deferred("set", "disabled", true)
		else:
			var explosion_instance = explosion.instance()
			explosion_instance.position = get_global_position()
			get_tree().get_root().add_child(explosion_instance)
			sound.stream = regBulletHit
			sound.play()
			hitBoxCollisionShape.call_deferred("set", "disabled", true)
			collision.call_deferred("set", "disabled", true)

func _on_bulletPenetration_area_entered(area):
	if area.is_in_group("enemy"):
		bulletHealth -= 1
		if bulletHealth == 0:
			self.set_collision_mask_bit(2, true)
#		if bulletHealth <= -1:
#			hitBox.call_deferred("set", "disabled", true)
#			hitBoxCollisionShape.call_deferred("set", "disabled", true)

func _on_homingArea_body_entered(body):
	if body.is_in_group('enemy') and homingBulletUnlocked:
		target = body


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_bulletHitSound_finished():
	if bulletHealth < 0:
		queue_free()
	if explosiveBulletUnlocked and is_instance_valid(self):
		hitBoxCollisionShape.scale = Vector2(1,1)


func _on_HitBox_body_entered(body):
	if body.is_in_group("enemy") and bulletHealth != 0 and is_instance_valid(self):
		hitBox.tempDisable()
		if explosiveBulletUnlocked and is_instance_valid(self):
			hitBoxCollisionShape.scale = Vector2(5,5)
			sound.stream = explosiveBulletHit
			if !sound.playing:
				sound.play()
		else:
			sound.stream = regBulletHit
			if !sound.playing:
				sound.play()
	if bulletHealth < 0:
		sound.play()
		
func _on_despawnTimer_timeout():
	self.queue_free()











