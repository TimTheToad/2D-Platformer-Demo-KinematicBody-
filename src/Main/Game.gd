extends Node
# This class contains controls that should always be accessible, like pausing
# the game or toggling the window full-screen.


# The "_" prefix is a convention to indicate that variables are private,
# that is to say, another node or script should not access them.
onready var _pause_menu = $InterfaceLayer/PauseMenu
onready var gameSaveData = preload("res://SaveData.gd")

var coinsCatchedSession
var enemiesKilledSession

var rng = RandomNumberGenerator.new()

func _init():
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()
	

func _ready():
	
	coinsCatchedSession = 0
	enemiesKilledSession = 0
	TichProfiler.connect("_save", self, "SaveData")
	TichProfiler.connect("_load", self, "LoadData")
	TichProfiler.connect("_change_level", self, "ChangeLevel")

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
	coin.ID = coindDict["ID"]
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
	
	var enemyGroup = load("res://src/Actors/EnemyGroup.gd").new()
	enemyGroup.enemyCount = count;
	
	for i in range(0, count):
		var enemyScene = load("res://src/Actors/EnemyCoin.tscn")
		var enemy = enemyScene.instance()
		enemy.group = enemyGroup;
		enemy.get_node("Coin").enemy = enemy
		var x = rng.randf_range(-100.0, 100.0)
		var y = rng.randf_range(-100.0,100.0)
		enemy.position = Vector2(x, y)
		parent.add_child(enemy)
	
	pass
	
func CreateEnemy(parent, enemyDict, group):
	
	var enemyScene
	
	if(enemyDict.has("Coin")):
		enemyScene = load("res://src/Actors/EnemyCoin.tscn")
	else:
		enemyScene = load("res://src/Actors/Enemy.tscn")
		
	var enemy = enemyScene.instance()
	parent.add_child(enemy)
	
	var animPlayer = enemy.find_node("AnimationPlayer")
	enemy.position = enemyDict["Position"]
	enemy.ID = enemyDict["ID"]
	enemy._velocity = enemyDict["Velocity"]
	enemy.group = group
	
	var coin = enemy.get_node_or_null("Coin")
	if(coin):
		var coinDict = enemyDict["Coin"]
		var ap = coin.find_node("AnimationPlayer")
		
		coin.position = coinDict["Position"]
		coin.name = coinDict["Name"]
		
		ap.current_animation = coinDict["Animation"]
		ap.play(coinDict["Animation"])
		ap.seek(coinDict["AnimPosition"])
		
		coin.enemy = enemy
		
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
	newSave.playerDict[player.name] = playerDict

	#----------Save Bullet Data--------------#

	var playerGun = $Level/Player/Sprite/Gun
	var gunChildCount = $Level/Player/Sprite/Gun.get_child_count()
	var bulletArray = []
	if(gunChildCount > 2):
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
		var coinChunkDict = {"Group": coinChunk.name, "coins" : []}

		for coin in coinChunk.get_children():
			var coinDict = {}
			var animPlayer = coin.find_node("AnimationPlayer")
			coinDict["Position"] =  coin.position
			coinDict["ID"] =  coin.ID
			coinDict["AnimPosition"] =  animPlayer.current_animation_position
			coinDict["Animation"] =  animPlayer.current_animation
			coinChunkDict["coins"].append(coinDict)

		newSave.coinArray.append(coinChunkDict) 

	#----------Save Enemy Data--------------#

	newSave.enemyDict["Children"] = $Level/Enemies.get_child_count()
	var enemyArr = []
	for enemy in $Level/Enemies.get_children():
		var animPlayer = enemy.find_node("AnimationPlayer")
		var enemyDictionary = {
			"Position": enemy.position, 
			"Velocity": enemy._velocity, 
			"ID" : enemy.ID, 
			"AnimPosition" : animPlayer.current_animation_position,
			"Animation" : animPlayer.current_animation,
			"Group" : enemy.group.get_instance_id() if enemy.group else null
			}
			#----------Save Enemy Coin Data--------------#
		var enemyCoin = enemy.get_node_or_null("Coin")
		
		if enemyCoin:
			var coinsDict = {}
			var ap = enemyCoin.find_node("AnimationPlayer")
			coinsDict["Position"] =  enemyCoin.position
			coinsDict["Name"] =  enemyCoin.name
			coinsDict["AnimPosition"] =  ap.current_animation_position
			coinsDict["Animation"] =  ap.current_animation
			enemyDictionary["Coin"] = coinsDict 
			
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

	newSave.musicDict = {"Name" : $Level/Music.name, "Position" : $Level/Music.get_playback_position()}
	
	#----------Save Score Data--------------#
	
	var sessionScore = {"Enemies" : enemiesKilledSession, "Coins" : coinsCatchedSession}
	var highScore = {"Enemies" : Statistics._enemyScore, "Coins" : Statistics._coinScore}
	
	newSave.gameScores = {"Session" : sessionScore, "HighScore" : highScore}
	
	
	ResourceSaver.save("res://savedScene.tich", newSave)
	pass

func LoadData():
	isLoading = true
	print("LOADING GAME")
	var loadGameData = load("res://savedScene.tich")
	
	#----------Load Enemies Data--------------#
	
	var parent = get_node("Level/Enemies")
	
	var enemyInGameArr = parent.get_children()
	var enemyInLoadArr = loadGameData.enemyDict["Enemies"]
	
	var inGameEnemyIDArr = []

	var groupDict = {}
	
	for enemy in enemyInGameArr:
		var exists = false
		
		for enemyDict in enemyInLoadArr:
			if enemy.ID == enemyDict["ID"]:
				exists = true
				break
			
		if not exists:
			print("Deleting enemy with ID: ", enemy.ID)
			enemy.queue_free()
		else:
			inGameEnemyIDArr.append(enemy.ID)
			if enemy.group && not groupDict.has(enemy.group.get_instance_id()):
				groupDict[enemy.group.get_instance_id()] = enemy.group	
		
		
	
	for j in range(enemyInLoadArr.size()):
		var index = inGameEnemyIDArr.find(enemyInLoadArr[j]["ID"])
		
		if index == -1:
			var groupID = enemyInLoadArr[j]["Group"]
			var group = null
			
			if groupID != null:
				if groupDict.has(groupID):
					group = groupDict[groupID]
				else:
					group = load("res://src/Actors/EnemyGroup.gd").new()
					groupDict[groupID] = group
				
				group.enemyCount += 1
				
			CreateEnemy(parent, enemyInLoadArr[j], group)
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
	var playerDict = loadGameData.playerDict[player.name]
	player.position = playerDict["Position"] # bug here! when platform moves up. Collision is not detected.
	player._velocity = playerDict["Velocity"]
	$Level/Player/Sprite.scale.x = playerDict["SpriteScale"]
	
	#----------Load Bullet Data--------------#
	var playerGun = $Level/Player/Sprite/Gun
	var gunChildCount =  playerGun.get_child_count()
	var bulletArray = loadGameData.playerDict["Bullets"]
	
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

	for coinChunk in $Level/Coins.get_children():
		
		for coinInGame in coinChunk.get_children():
			
			var exists = false
			for chunkInLoad in loadGameData.coinArray:

				for coinInLoad in chunkInLoad["coins"]:

					if coinInLoad["ID"] == coinInGame.ID:
						exists = true
						break
					
				if exists:
					break
			if not exists:
				coinInGame.queue_free()
	
	for chunkInLoad in loadGameData.coinArray:
		
		var chunkInGame = $Level/Coins.get_node(chunkInLoad["Group"])
		for coinInLoad in chunkInLoad["coins"]:
			
			var exists = false
		
			for coinInGame in chunkInGame.get_children():
				if coinInLoad["ID"] == coinInGame.ID:
					exists = true
					var animPlayer = coinInGame.find_node("AnimationPlayer")
					
					coinInGame.position = coinInLoad["Position"]
					animPlayer.current_animation = coinInLoad["Animation"]
					animPlayer.seek(coinInLoad["AnimPosition"])
					break
					
			if not exists:
				CreateCoin(chunkInGame, coinInLoad)
		
		#----------Load Music Data--------------#
		
		var musicNode = find_node(loadGameData.musicDict["Name"])
		musicNode.play(loadGameData.musicDict["Position"])
		
		#----------Load Score Data--------------#
		
		enemiesKilledSession = loadGameData.gameScores["Session"]["Enemies"]
		coinsCatchedSession = loadGameData.gameScores["Session"]["Coins"]
		
		Statistics._enemyScore = loadGameData.gameScores["HighScore"]["Enemies"]
		Statistics._coinScore = loadGameData.gameScores["HighScore"]["Coins"]
	pass

func ResetGame():
	
	# Remove the current scene
	queue_free()

	# Add the next level
	var gameScene = load("res://src/Main/Game.tscn")
	var game = gameScene.instance()
	
	get_tree().get_root().add_child(game)
	
	get_tree().change_scene_to(game)
	
	
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("save") and !isSaving:
		SaveData()
		isSaving = false
	if Input.is_action_just_pressed("load") and !isLoading:
		LoadData()
		isLoading = false
		
	if Input.is_action_just_pressed("Reset_Game"):
		ResetGame()
		
	if Input.is_action_just_pressed("spawn_coin"):
		var coinSpawnerNode = $Level/Coins/CoinSpawner
		var enemySpawnerNode = $Level/Enemies

		SpawnCoin(coinSpawnerNode, 100)
		SpawnEnemy(enemySpawnerNode, 10)

	if Input.is_action_just_pressed("Change_Level"):
		ChangeLevel()
				
	if Input.is_action_just_pressed("Show_Score"):	
		print("---------------SESSION INFO-----------------")
		print("Coins catched this session: ", coinsCatchedSession)
		print("Enemies killed this session: ", enemiesKilledSession)
		
		print("Most Coins catched: ", Statistics._coinScore)
		print("Most Enemies killed: ", Statistics._enemyScore)
		
	if coinsCatchedSession > Statistics._coinScore:
		Statistics._coinScore = coinsCatchedSession
		
	if enemiesKilledSession > Statistics._enemyScore:
		Statistics._enemyScore = enemiesKilledSession
		
	pass

var currentLevel = "res://src/Level/Level.tscn"

func ChangeLevel():
	var player = $Level/Player
	$Level.remove_child(player)
	self.get_node("Level").free()
	
	if currentLevel == "res://src/Level/Level.tscn":
		currentLevel = "res://src/Level/Level1st.tscn"
		print("Changeing to Scene Complexity 1")
	elif currentLevel == "res://src/Level/Level1st.tscn":
		currentLevel = "res://src/Level/Level.tscn"
		print("Changeing to Scene Complexity 2 & 3")
		
	var newLevel = load(currentLevel).instance()
	newLevel.name = "Level"
	newLevel.add_child(player)
	self.add_child(newLevel)
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
