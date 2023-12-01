extends CharacterBody2D

func _ready():
	($"NewSound" as AudioStreamPlayer2D).play();

func _physics_process(delta : float) -> void:
	rotation_degrees += 24 * delta;

func die() -> void:
	($DieSound as AudioStreamPlayer2D).play();
	visible = false;
	($"CollisionShape2D" as CollisionShape2D).disabled = true;
	
func _on_die_sound_finished() -> void:
	queue_free();
