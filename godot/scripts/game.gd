extends Node2D
class_name game

static var score : int = 0;

func _ready() -> void:
	($"UI/Pseudo" as RichTextLabel).text = "[center]%s\n#%s[/center]" % [connection.pseudo, connection.identifier];

func modifyScore(amount : int) -> void:
	score += amount;
	($"UI/StarsCount/RichTextLabel" as RichTextLabel).text = "[center][b]%s[/b][/center]" % [score];
