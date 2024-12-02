extends Node2D

var rng : RandomNumberGenerator = RandomNumberGenerator.new();
var maxStars : int = 20;

func _on_timer_timeout() -> void:
	if get_child_count() < 1+maxStars:
		var posX : int = rng.randi_range(64, 3000-64);
		var posY : int = rng.randi_range(64, 1500-64);

		var body : CharacterBody2D = preload("res://scenes/star.tscn").instantiate();
		body.position = Vector2(posX, posY);

		add_child(body);
