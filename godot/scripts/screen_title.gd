extends Control

func _process(delta : float) -> void:
	var mouseDir : Vector2 = get_global_mouse_position() - Vector2(1920/2, 1080/2)
	var angle : float = atan2(mouseDir.y, mouseDir.x);
	
	var textureRect : TextureRect =  $"TextureRect";
	textureRect.rotation = angle;
	textureRect.flip_v = (angle >= PI/2 or angle <= -PI/2);

func _on_text_timer_timeout() -> void:
	($"RichTextLabel" as RichTextLabel).visible = !($"RichTextLabel" as RichTextLabel).visible;
