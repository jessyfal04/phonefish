extends Control

func _ready() -> void:
	($"RichTextLabel" as RichTextLabel).text = "[center][b]Bravo %s#%s\nVous avez un score de %s ![/b][/center]" % [connection.pseudo, connection.identifier, game.score] ;

	($"HTTPRequest" as HTTPRequest).request("https://jessyfallavier.dev/phonefish/api/scores/register?pseudo=%s&identifier=%s&token=%s&score=%d" % [connection.pseudo, connection.identifier, connection.token, game.score], [],  HTTPClient.METHOD_POST);
	#($"HTTPRequest" as HTTPRequest).request("http://127.0.0.1:5000/scores/register?pseudo=%s&identifier=%s&token=%s&score=%d" % [connection.pseudo, connection.identifier, connection.token, game.score], [],  HTTPClient.METHOD_POST);
