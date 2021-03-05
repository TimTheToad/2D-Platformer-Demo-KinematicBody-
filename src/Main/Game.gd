extends Node
# This class contains controls that should always be accessible, like pausing
# the game or toggling the window full-screen.


# The "_" prefix is a convention to indicate that variables are private,
# that is to say, another node or script should not access them.
onready var _pause_menu = $InterfaceLayer/PauseMenu
onready var gameSaveData = preload("res://SaveData.gd")

var saveArray = []

var rng = RandomNumberGenerator.new()
func _init():
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()
	

func _ready():
	
	TichProfiler.connect("_save", self, "SaveData")
	TichProfiler.connect("_load", self, "LoadData")
#

	pass

func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		# We need to clean up a little bit first to avoid Viewport errors.
		if name == "Splitscreen":
			$Black/SplitContainer/ViewportContainer1.free()
			$Black.queue_free()

var isSaving = false
var isLoading = false



func CreateCoin(parent, coindDict):
	
	var coinScene = load("res://src/Objects/Coin.tscn")
	var coin = coinScene.instance()
	var animPlayer = coin.find_node("AnimationPlayer")
	parent.add_child(coin)
	
	coin.position = coindDict["Position"]
	coin.name = coindDict["Name"]
	animPlayer.current_animation = coindDict["Animation"]
	animPlayer.play(coindDict["Animation"])
	animPlayer.seek(coindDict["AnimPosition"])
	pass
	
func SpawnCoin(parent, count):
	
	for i in range(0, count):
		var coinScene = load("res://src/Objects/Coin.tscn")
		var coin = coinScene.instance()
		var x = rng.randf_range(-100.0, 100.0)
		var y = rng.randf_range(-100.0,100.0)
		coin.position = Vector2(x, y)
		parent.add_child(coin)
	
	pass
	
func SpawnEnemy(parent, count):
	
	for i in range(0, count):
		var enemyScene = load("res://src/Actors/Enemy.tscn")
		var enemy = enemyScene.instance()
		var x = rng.randf_range(-100.0, 100.0)
		var y = rng.randf_range(-100.0,100.0)
		enemy.position = Vector2(x, y)
		parent.add_child(enemy)
	
	pass
	
func CreateEnemy(parent, enemyDict):
	
	var enemyScene = load("res://src/Actors/Enemy.tscn")
	var enemy = enemyScene.instance()
	parent.add_child(enemy)
	
	var animPlayer = enemy.find_node("AnimationPlayer")
	enemy.position = enemyDict["Position"]
	enemy.name = enemyDict["Name"]
	enemy._velocity = enemyDict["Velocity"]
	if(enemyDict["Animation"] == "destroy"):
		enemy._state = 1
	animPlayer.current_animation = enemyDict["Animation"]
	animPlayer.play(enemyDict["Animation"])
	animPlayer.seek(enemyDict["AnimPosition"])
	#might need to add animation time etc etc. but for now this should work
	
	pass

func SaveData():
	
	
	isSaving = true
	print("SAVING GAME")
	var newSave = gameSaveData.new()
	
	#----------Save Player Data--------------#

	var player = $Level/Player
	
	var playerDict = {
		"Position": player.position, 
		"Velocity": player._velocity, 
		"SpriteScale": $Level/Player/Sprite.scale.x
		} 
	newSave.playerDict[player.get_path()] = playerDict

	#----------Save Bullet Data--------------#

	var playerGun = $Level/Player/Sprite/Gun
	var gunChildCount = $Level/Player/Sprite/Gun.get_child_count()
	if(gunChildCount > 2):
		var bulletArray = []
		for i in range(2, gunChildCount):
			var bulletDict = {}
			bulletDict = {
				"Velocity" : playerGun.get_child(i).linear_velocity,
				"Position" : playerGun.get_child(i).global_position
			}
			bulletArray.append(bulletDict)

		newSave.playerDict["Bullets"] = bulletArray

	#----------Save Coin Data--------------#

	var iterator = 0
	for coinChunk in $Level/Coins.get_children():
		var coinChunkPath = {coinChunk.get_path() : {}}
		var coinChunkDict = {}
		coinChunkDict["children"] = coinChunk.get_child_count()

		var dict = []

		for coin in coinChunk.get_children():
			var coinsDict = {}
			var animPlayer = coin.find_node("AnimationPlayer")
			coinsDict["Position"] =  coin.position
			coinsDict["Name"] =  coin.name
			coinsDict["AnimPosition"] =  animPlayer.current_animation_position
			coinsDict["Animation"] =  animPlayer.current_animation
			dict.append(coinsDict)

		coinChunkDict["coins"] = dict
		coinChunkPath[coinChunk.get_path()] = coinChunkDict

		newSave.coinDict.append(coinChunkPath) 

	#----------Save Enemy Data--------------#

	newSave.enemyDict["Children"] = $Level/Enemies.get_child_count()
	var enemyArr = []
	for enemy in $Level/Enemies.get_children():
		var animPlayer = enemy.find_node("AnimationPlayer")
		var enemyDictionary = {
			"Position": enemy.position, 
			"Velocity": enemy._velocity, 
			"Name" : enemy.name, 
			"AnimPosition" : animPlayer.current_animation_position,
			"Animation" : animPlayer.current_animation}
		enemyArr.append(enemyDictionary)
	newSave.enemyDict["Enemies"] = enemyArr
		
	#----------Save Moving Platform Data--------------#

	var platform = NodePath("Platforms/Platform1")
	var platformDictionary = {"Position": $Level/Platforms/Platform1/AnimationPlayer.current_animation_position}
	newSave.platformDict.append(platformDictionary)
	
	platform = NodePath("Platforms/Platform2")
	platformDictionary = {"Position": $Level/Platforms/Platform2/AnimationPlayer.current_animation_position}
	newSave.platformDict.append(platformDictionary)
	
	
	#----------Save Music Data--------------#

	newSave.musicDict = {"Path" : $Level/Music.get_path(), "Position" : $Level/Music.get_playback_position()}

	saveArray.append(newSave)
	ResourceSaver.save("res://savedScene.tich", newSave)

	pass


func AddDummyNodeRecursevly(parent, height):
#
#	if height != 0:
#		var coinScene = load("res://src/Objects/Coin.tscn")
#		var coin = coinScene.instance()
#		height = height - 1
#		AddDummyNodeRecursevly(coin, height)
#		parent.add_child(coin)
	pass

func LoadData():
	isLoading = true
	print("LOADING GAME")
	var loadGameData = load("res://savedScene.tich")
	
	#----------Load Enemies Data--------------#
	
	var parent = get_node("Level/Enemies")
	
	var enemyInGameArr = parent.get_children()
	var enemyInLoadArr = loadGameData.enemyDict["Enemies"]
	
	var inGameNames = []
	
	for i in range(0, enemyInGameArr.size()):
		inGameNames.append(enemyInGameArr[i].name)

	for j in range(enemyInLoadArr.size()):
		var index = inGameNames.find(enemyInLoadArr[j]["Name"])
		if index == -1:
			CreateEnemy(parent, enemyInLoadArr[j])
		else:
			var enemy = parent.get_child(index)
			var animPlayer = enemy.find_node("AnimationPlayer")
			animPlayer.current_animation = enemyInLoadArr[j]["Animation"]
			animPlayer.play(enemyInLoadArr[j]["Animation"])
			animPlayer.seek(enemyInLoadArr[j]["AnimPosition"])
			enemy.position = enemyInLoadArr[j]["Position"]
			enemy._velocity = enemyInLoadArr[j]["Velocity"]


	#----------Load Player Data--------------#
	var player = $Level/Player
	var playerDict = loadGameData.playerDict[player.get_path()]
	player.position = playerDict["Position"] # bug here! when platform moves up. Collision is not detected.
	player._velocity = playerDict["Velocity"]
	$Level/Player/Sprite.scale.x = playerDict["SpriteScale"]
	
	#----------Load Bullet Data--------------#
	var playerGun = $Level/Player/Sprite/Gun
	var bulletArray = loadGameData.playerDict["Bullets"]
	var gunChildCount =  playerGun.get_child_count()
	
	if(gunChildCount > 2): #Remove existing bullets
		for i in range(2, gunChildCount):
			if(playerGun.get_child(i)):
				playerGun.get_child(i).free()
	
	for i in range(0, bulletArray.size()): # Add new bullets
		var bulletScene = load("res://src/Objects/Bullet.tscn")
		var bullet = bulletScene.instance();
		bullet.set_as_toplevel(true)
		bullet.global_position = bulletArray[i]["Position"]
		bullet.linear_velocity = bulletArray[i]["Velocity"]
		playerGun.add_child(bullet)
	
	
	#----------Load Moving Platform Data--------------#
	
	var platform1 = loadGameData.platformDict[0]
	var platform2= loadGameData.platformDict[1]
	
	$Level/Platforms/Platform1/AnimationPlayer.seek(platform1["Position"]) # bug here! when platform moves up. Collision is not detected.
	$Level/Platforms/Platform2/AnimationPlayer.seek(platform2["Position"])
	
	
	#----------Load Coin Data--------------#
	var it = 0

	for coinChunk in $Level/Coins.get_children():

		var loadArr = loadGameData.coinDict[it]
		var dict = loadArr[coinChunk.get_path()]
		it = it + 1
		
		var childCountInGame = coinChunk.get_child_count()
		var childCountInLoad = dict["children"]
		
		if childCountInLoad > childCountInGame : # should add a coin to game from save file
			var coinsInChunk = coinChunk.get_children()
			var treeNames = []
			var coinsDictInLoad = dict["coins"]
			
			for j in range(0, coinsInChunk.size()):
				treeNames.append(coinsInChunk[j].name)
			
			for i in range(0, coinsDictInLoad.size()):
				if treeNames.has(coinsDictInLoad[i]["Name"]):
					continue
				else:
					CreateCoin(coinChunk, coinsDictInLoad[i])
		elif childCountInLoad < childCountInGame: # Should remove a coin from the game 
			var namesInLoad = []
			for i in range(0, childCountInLoad):
				namesInLoad.append(dict["coins"][i]["Name"])
				
			var coinsInChunk = coinChunk.get_children()
			var treeNames = []
			for j in range(0, coinsInChunk.size()):
				var coinName = coinsInChunk[j].name
				if not namesInLoad.has(coinName):
					coinChunk.get_node(coinName).free()
		
		#----------Load Music Data--------------#
		
		var musicNode = get_node(loadGameData.musicDict["Path"])
		musicNode.play(loadGameData.musicDict["Position"])
	pass

func VerifySavedData():
	#maybe we can skip this
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("save") and !isSaving:
		SaveData()
		isSaving = false
	if Input.is_action_just_pressed("load") and !isLoading:
		LoadData()
		isLoading = false
		
		
	if Input.is_action_just_pressed("spawn_coin"):
		var coinSpawnerNode = $Level/Coins/CoinSpawner
		var enemySpawnerNode = $Level/Enemies

		SpawnCoin(coinSpawnerNode, 100)
		SpawnEnemy(enemySpawnerNode, 10)
		
	pass

func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		get_tree().set_input_as_handled()
	# The GlobalControls node, in the Stage scene, is set to process even
	# when the game is paused, so this code keeps running.
	# To see that, select GlobalControls, and scroll down to the Pause category
	# in the inspector.
	elif event.is_action_pressed("toggle_pause"):
		var tree = get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			_pause_menu.open()
		else:
			_pause_menu.close()
		get_tree().set_input_as_handled()


	elif event.is_action_pressed("splitscreen"):
		if name == "Splitscreen":
			# We need to clean up a little bit first to avoid Viewport errors.
			$Black/SplitContainer/ViewportContainer1.free()
			$Black.queue_free()
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://src/Main/Game.tscn")
		else:
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://src/Main/Splitscreen.tscn")
