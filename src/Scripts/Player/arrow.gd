extends Sprite

onready var store = get_tree().get_root().find_node('Store', true, false)

func _ready():
	self.visible = false

func _physics_process(_delta):
	if is_instance_valid(store):
		self.visible = true
		look_at(store.global_position)
	elif !is_instance_valid(store):
		self.visible = false
	
