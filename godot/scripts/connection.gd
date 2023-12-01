extends Control
class_name connection

static var pseudo : String;
static var identifier : String;
static var token : String;
var httpRequest : HTTPRequest;

func _ready() -> void:
	httpRequest = $"HTTPRequest";

func _on_http_request_request_completed(result : int, response_code: int, headers : PackedStringArray, body : PackedByteArray) -> void:
	
	if (response_code == 200):
		var json : Dictionary = JSON.parse_string(body.get_string_from_utf8());
		pseudo = json["pseudo"];
		identifier = json["identifier"];
		token = json["token"];
		
		$"..".call("changeState", main.GAMESTATE.GAME);
	
	else:
		($"HBoxContainer/VerifyPseudo" as Button).self_modulate = Color("#ff7675");
		
func _on_verify_pseudo_pressed() -> void:
	($"HBoxContainer/VerifyPseudo" as Button).self_modulate = Color("#FFFFFF");
	pseudo = ($"HBoxContainer/Pseudo" as LineEdit).text;
	
	httpRequest.request("https://vps.jessyfallavier.dev/phonefish/api/users/register?pseudo=%s" % [pseudo], [], HTTPClient.METHOD_POST);

func playKey() -> void:
	($"Key" as AudioStreamPlayer).play();

func _on_pseudo_text_changed(new_text : String) -> void:
	playKey();
	
func _on_pseudo_text_submitted(new_text : String) -> void:
	playKey();
	_on_verify_pseudo_pressed();


