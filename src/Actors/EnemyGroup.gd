extends Node

var isDead = false
var enemyCount = 0

func destroy():
	isDead = true
	enemyCount = enemyCount - 1
	if(enemyCount == 0):
		queue_free()
