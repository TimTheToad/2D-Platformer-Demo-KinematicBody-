class_name Coin
extends Area2D
# Collectible that disappears when the player touches it.

onready var animation_player = $AnimationPlayer

var enemy = null
var ID = -1
# The Coins only detects collisions with the Player thanks to its collision mask.
# This prevents other characters such as enemies from picking up coins.

# When the player collides with a coin, the coin plays its "picked" animation.
# The animation takes cares of making the coin disappear, but also deactivates its
# collisions and frees it from memory, saving us from writing more complex code.
# Click the AnimationPlayer node to see the animation timeline.

func _ready():
	ID = Statistics.CreateID()
	pass

func _on_body_entered(_body):
	pickup()
	if(enemy != null):
		enemy.destroy()
		
func pickup():
	animation_player.play("picked")
	var game = get_parent().get_parent().get_parent().get_parent()
	game.coinsCatchedSession = game.coinsCatchedSession + 1
