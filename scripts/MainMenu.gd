extends Control
@export var Address = "localhost"
@export var port = 8910
var peer

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	

func peer_connected(id):
	print("Player Connected " + str(id))
	

# this get called on the server and clients
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	


# called only from clients
func connected_to_server():
	print("connected To Sever!")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())
	

# called only from clients
func connection_failed():
	print("Couldnt Connect")
	
	
@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] ={
			"name" : name,
			"id" : id,
			"score": 0
		}
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)
			

@rpc("any_peer","call_local")
func StartGame():
	var scene = load("res://scenes/level.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players!")

func _on_host_pressed(): 
	hostGame()
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())
	$Address.hide()
	$Start.show()
	$Join.disabled = true

func _on_join_pressed():
	Address = $Address.text
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)	
	
	$Join.disabled = true

func _on_start_pressed():
	StartGame.rpc()
	
	
