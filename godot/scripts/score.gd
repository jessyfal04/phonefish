extends Control

func _ready() -> void:
	($"RichTextLabel" as RichTextLabel).text = "[center][b]Bravo %s#%s\nVous avez un score de %s ![/b][/center]" % [connection.pseudo, connection.identifier, game.score] ;

	($"HTTPRequest" as HTTPRequest).request("https://vps.jessyfallavier.dev/phonefish/api/scores/register?pseudo=%s&identifier=%s&token=%s&score=%d" % [connection.pseudo, connection.identifier, connection.token, game.score], [],  HTTPClient.METHOD_POST);
