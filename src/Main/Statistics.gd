extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _coinScore;
var _enemyScore;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	
	if Input.is_action_just_pressed("Show_Score"):
		print("Highest coins catched: ", _coinScore)
		print("Highest enemies killed: ", _enemyScore)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
