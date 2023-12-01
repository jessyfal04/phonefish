extends CharacterBody2D

var speed : int = 10000;

func _physics_process(delta: float) -> void:
	var direction : Vector2 = $"../../Fish".position - position;
	direction = direction.normalized() * speed * delta;
	velocity = direction;
	move_and_slide();

func die(attacked: bool) -> void:
	if attacked:
		($DieSound as AudioStreamPlayer2D).play();
		visible = false;
		($"CollisionShape2D" as CollisionShape2D).set_deferred("disabled", true);
	else:
		queue_free();

func _on_die_sound_finished() -> void:
	queue_free();
