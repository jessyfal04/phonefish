extends Control
class_name connection

static var pseudo : String;
static var identifier : String;
static var token : String;
static var code : String;
var httpRequest : HTTPRequest;

func _ready() -> void:
	httpRequest = $"HTTPRequest";

func _on_http_request_request_completed(result : int, response_code: int, headers : PackedStringArray, body : PackedByteArray) -> void:
	
	if (response_code == 200):
		var json : Dictionary = JSON.parse_string(body.get_string_from_utf8());
		pseudo = json["pseudo"];
		identifier = json["identifier"];
		token = json["token"];
		code = json["code"];
		
		($PseudoContainer as HFlowContainer).visible = false;
		($ConnectionInfos as RichTextLabel).visible = true;
		($ConnectionInfos as RichTextLabel).text = "[center][b] Connectez vous sur la page mobile avec ces infos : [/b]\n\nPseudo : %s \nIdentifier : %s\nCode : %s[/center]" % [connection.pseudo, connection.identifier, connection.code];
		
		$"../WebSocket".call("set_process", true);
		$"../WebSocket".call("connectWS");
	else:
		($"PseudoContainer/VerifyPseudo" as Button).self_modulate = Color("#ff7675");
		
func _on_verify_pseudo_pressed() -> void:
	($"PseudoContainer/VerifyPseudo" as Button).self_modulate = Color("#FFFFFF");
	pseudo = ($"PseudoContainer/Pseudo" as LineEdit).text;
	
	httpRequest.request("https://jessyfal04.dev/api/phonefish/users/register?pseudo=%s" % [pseudo], [], HTTPClient.METHOD_POST);
	#httpRequest.request("http://127.0.0.1:5000/users/register?pseudo=%s" % [pseudo], [], HTTPClient.METHOD_POST);
func playKey() -> void:
	($"Key" as AudioStreamPlayer).play();

func _on_pseudo_text_changed(new_text : String) -> void:
	playKey();
	
func _on_pseudo_text_submitted(new_text : String) -> void:
	playKey();
	_on_verify_pseudo_pressed();

func open():
	$"..".call("changeState", main.GAMESTATE.GAME);

