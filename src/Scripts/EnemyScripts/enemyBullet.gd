extends RigidBody2D

var speed = 250
var explosion = preload("res://Scenes/Explosion.tscn")

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_enemyBullet_body_entered(body):
	if body.is_in_group('player'):
		self.visible = false
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		yield(get_tree().create_timer(0.3), "timeout")
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
