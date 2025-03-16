extends Node2D

@onready var texturePath = $Texture

var type:String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func load_icon(_name:String) -> void:
	type = _name
	if("fire_arrow"):
		texturePath.texture = load("res://image/attack/image.png")
	elif("ice"):
		texturePath.texture = load("res://image/attack/glace.png")
		
		
