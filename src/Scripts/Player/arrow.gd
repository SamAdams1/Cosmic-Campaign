extends Sprite



func _ready():
	self.visible = false

func _physics_process(_delta):
	var store = Global.store
	if is_instance_valid(store):
		self.visible = true
		look_at(store.global_position)
	elif !is_instance_valid(store):
		self.visible = false
	
