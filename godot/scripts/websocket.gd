extends Node

var websocket : WebSocketPeer = WebSocketPeer.new()

var needToAccept : bool = false;

func _ready() -> void:
	set_process(false);

func connectWS() -> void:
	websocket.connect_to_url("wss://jessyfal04.dev/ws/phonefish");
	needToAccept = true;

func send(message : Dictionary) -> void:
	websocket.send_text(JSON.stringify(message))

func _process(delta : float) -> void:
	websocket.poll()
	var state : WebSocketPeer.State = websocket.get_ready_state()
	
	if state == WebSocketPeer.STATE_OPEN:
		if needToAccept:
			needToAccept = false;
			send({"ACTION": "ACCEPT", "ARGS": {"pseudo": connection.pseudo, "identifier": connection.identifier, "token": connection.token}})
			
		while websocket.get_available_packet_count():
			var message : Dictionary = JSON.parse_string(websocket.get_packet().get_string_from_utf8());
			print(message);
			if message["ACTION"] == "OPEN" and main.gameState == main.GAMESTATE.CONNECTION:
				$"../Connection".call("open");
			elif message["ACTION"] == "VIBRATE" and main.gameState == main.GAMESTATE.GAME:
				print("lll");
				Input.action_press("catch");
				
	elif state == WebSocketPeer.STATE_CLOSED:
		var code : int = websocket.get_close_code();
		var reason : String = websocket.get_close_reason();
		print("Webwebsocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1]);
		connectWS();
