extends Node2D
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _on_timer_timeout() -> void:
	var posX : int = rng.randi_range(64, 3000-64);
	var posY : int = rng.randi_range(64, 3000-64);

	var body : CharacterBody2D = preload("res://scenes/urchin.tscn").instantiate();
	body.position = Vector2(posX, posY);

	add_child(body);
